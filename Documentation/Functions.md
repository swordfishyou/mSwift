
# Functions
In Swift functions are _first-class values_. This means we can pass them as arguments to another functions and functions can return other functions as computation result. 

Let's talk about function's type. First of all, Swift has _strong type system_: it has strict type rules. Understanding type's very important if we want to use such powerful feature as _type inference_.

Consider a function `f` taking a single argument `x` of type `A`. If we execute function `f` with a given argument we obtain a new value `B`. This means our function takes type `A` as argument and returns type `B` as the result. Since function is first-class value it also has a type. In our case the type is `(A) -> B`.

Functions also may take multiple arguments. They also have their own types, like `(A, B) -> C` or `(A, B, C) -> D` and so on. Such notation is _generic_ and we can use any types, even if all of them are the same.

## Pure functions
Our functions often use properties of classes, structures or some external constants. We also might change (_mutate_) variable's value in function. Such functions are _impure_, since result of their execution depends on some _external_ values, not only the arguments. In contrast, _pure function_ result depends only on arguments the function takes. Moreover, pure functions don't mutate any variables. All the things making a function impure are called _side effects_.

In OOP realities it's pretty hard to avoid side effects since they are not considered as something wrong. Moreover, trying to avoid side effects introduces a level of unnececary complexity of the code, brings up front questions like memory management, mutability and so on. Generally speaking, pure functions in OOP are not even needed.

The only way to implement pure functions in Swift is using of _structures_ and _static functions_. This way we resolve memory management and immutability issues.

## Pipeline
In object-oriented languages we often assign result of a function execution to _variables_. We also pass variables as arguments to next functions. Or, in other words, we pass the result of one function to another. This is a _pipeline_. Here is a brief example:

```swift
countElements(of: lines(in: getContents(from: "http://github.com")))
```

Type inference and _function composition_ make such code short and clear, take a look:

```swift
getContents |> lines |> countElements >>> "http://github.com"
```

Here order of the execution is changed. This is done in order to use function composition with [curried functions](/Currying.md).

We've already discussed both `Array` and `Optional` and have seen they are specific containers. Applying functions to such values differs a bit, but still both these types provide handful interface for _pipeline_ application.