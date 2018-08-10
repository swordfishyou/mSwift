# Applicative
**m-Swift** introduces an operators group called `Applicative` designed to apply functions to arguments.

## Apply a Function
```swift
import mSwift

curry(User.create) >>> firstrname >>> lastname >>> email
```

Since one can't curry constructor we need to implement a static function
```swift
struct User {
    let firstname: String
    let lastname: String
    let email: String
    
    static func create(firstname: String,
                       lastname: String,
                       email: String) -> User {
        return User(firstname: firstname,
                    lastname: lastname,
                    email: email)
    }
}
```

## Function Composition
As the name sugests, this technique creates one function from multiple. Consider creating of an `UIImage` from `CIImage`of specific size
```swift
func image(form image: CIImage, scaledTo size: CGSize) -> UIImage {
    return UIImage(ciImage: image.transformed(by: scaleTransform(from: image.extent.size, to: size)))
}

func scaleTransform(from originalSize: CGSize,
                                   to requestedSize: CGSize) -> CGAffineTransform {
    ...
}
```

If we use function composition and currying `image(from:scaledTo:)` is implemented like
```swift
extension UIImage {
    static func image(ciImage: CIImage) -> UIImage {
        return UIImage(ciImage: ciImage)
    }
}

func image(form image: CIImage, scaledTo size: CGSize) -> UIImage {
    return curry(scaleTransform) >>> image.extent.size |> image.transformed |> UIImage.image >>> size
}
```

Here `curry(scaleTransform)` has type `(CGSize) -> (CGSize) -> CGAffineTransform` while `image.transformed` is function of type `(CGAffineTransform) -> CIImage`. In order to use curried funtion here we perfom partial application and `curry(scaleTransform) >>> image.extent.size` type is `(CGSize) -> CGAffineTransform`. This funtion we use for composition.

Inverted order of the functions is implemented in order to avoid bracers for partial application.

## Apply a Function to `Optional`
Using optional binding we can apply function to the value wrapped in `Optional`
```swift
if let token = tokenStorage.currentToken {
    formatAuthorizationHeader(token: token)
}

func formatAuthorizationHeader(token: String) -> String {
    ...
}
```

Or we can use `map`
```swift
tokenStorage.currentToken(formatAuthorizationHeader)
```

**mSwift** makes this notation even shorter
```swift
import mSwift

formatAuthorizationHeader <^> tokenStorage.currentToken
```

Operator `<^>` returns another `Optional`. This is a trait of container types like `Optional`: applying functions returns a value wrapped to the same container. In case of curried functions this means such operator returns an `Optional` function. In order to apply such functions we use `<*>` operator. Consider multiplication of two optional integers

```swift
import mSwift

let a: Int? = 5
let b: Int? = nil

let product = curry(*) <^> a <*> b
```

For sure, extending `Optional` also helps here
```swift
extension Optional where Wrapped: Numeric {
    static func *(_ lhs: Wrapped?, rhs: Wrapped?) -> Wrapped? {
        switch (lhs, rhs) {
        case let (.some(val1), .some(val2)):
            return val1 * val2
        default:
            return nil
        }
    }
}
```

The more operations we need, the more extensions we have. Moreover, we override and duplicate already implemented functionality. **mSwift** allows you stay DRY here. Such approach shines in tasks where you perform multiple operations with `Optional` since you don't have to unwrap the value.