import Foundation

infix operator <^>: ApplicativePrecedence
/**
 Maps a function over the value, wrapped into an `Optional`
 
 ```
 protocol TokenProvider {
    var currentToken: String? { get }
 }
 
 func formatToken(_ token: String) -> String { ... }
 let formattedToken = formatToken <^> tokenProvider.currentToken
 ```
 
 - parameters:
    - function: a function to apply
    - arg: an `Optional` to map over
 
 - returns: result of the `function` evaluation wrapped into an `Optional`
 */
public func <^><A, B>(_ function: (A) -> B, arg: A?) -> B? {
    return arg.map(function)
}

infix operator <*>: ApplicativePrecedence
/**
 Applies a function to the value, wrapped into an `Optional`
 
 ```
 let a: Int? = 5
 let b: Int? = nil
 let min = curry(<) <^> a <*> b
 ```
 
 - parameters:
    - function: a function to apply
    - arg: an `Optional` wrapping function's argument
 
 - returns: result of the `function` evaluation wrapped into an `Optional`
 */
public func <*><A, B>(_ transform: ((A) -> B)?, arg: A?) -> B? {
    return transform.flatMap { arg.map($0) }
}

infix operator |>>: BindingPrecedence
/**
 Binds an `Optional` to another one
 
 ```
 let a: Int? = 5
 let b: Int? = nil
 let min = curry(<) <^> a <*> b
 ```
 
 - parameters:
 - function: a function to apply
 - arg: an `Optional` wrapping function's argument
 
 - returns: result of the `function` evaluation wrapped into an `Optional`
 */
public func |>><A, B>(_ transform: ((A) -> B?)?, arg: A?) -> B? {
    return transform.flatMap { arg.flatMap($0) }
}
