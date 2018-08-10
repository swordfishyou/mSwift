#Binding
Operations on container types like `Optional` return another container as the result. There are functions that take plain value as argument and return container type, i.e. `(A) -> B?` in case of `Optional` or `(A) -> [B]` for `Array`. Applying such functions to container type values is named _binding_.

## `Optional`
Consider a QR code generator. We generate an `UIImage` of requested size for a given `String`
```swift
func generate(from string: String, size requestedSize: CGSize) -> UIImage? {
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    filter.setValue(string.data(using: String.Encoding.ascii), forKey: "inputMessage")
    guard let image = filter.outputImage else { return nil }
    let transform = scaleTransform(from: image.extent.size, to: requestedSize)
    return UIImage(ciImage: image.transformed(by: transform))
}

func scaleTransform(from originalSize: CGSize,
                    to requestedSize: CGSize) -> CGAffineTransform {
    ...
}
```

This example shows how does code benefit from **mSwift** notation for pure computations
```swift
import mSwift

struct QRCodeImageGenerator {
    static func generate(from string: String, size requestedSize: CGSize) -> UIImage? {
        return curry(image) <*> curry(codeImage) |>> CIFilter(name: "CIQRCodeGenerator") |>> string <*> requestedSize
    }
    
    private static func codeImage(from filter: CIFilter, string: String) -> CIImage? {
        ...
    }
    
    private static func image(form image: CIImage, scaledTo size: CGSize) -> UIImage {
        ...
    }
    
    private static func scaleTransform(from originalSize: CGSize,
                        to requestedSize: CGSize) -> CGAffineTransform {
        ...
    }
}
```

Here binding happens for `codeImage` function. Currying transorms it to a function of type `(CIFilter) -> (String) -> CIImage?`. Binding the function to `CIFilter(name: "CIQRCodeGenerator")` results an optional function of type `((String) -> CIImage?)?`. That's why we also bind this partially applied function to a plain value of `string`. As the result we have an optional `CIImage`. Function `image` is an ordinary one (in terms of containers). So we just [apply](../Documentation/Applicative.md#apply-a-function-to-optional) it to resulting `CIImage?`.