import Foundation

precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: NilCoalescingPrecedence
}

/**
 Applies a given function to an argument.
 
 ```
 func formatToken(_ token: String) -> String { ... }
 let tokenString = ...
 let formattedToken = formatToken >>> tokenString
 ```
 
 - parameters:
    - function: a function to evaluate
    - argument: an argument to pass
 
 - returns: result of the `function` evaluation
 */
infix operator >>>: ApplicativePrecedence
public func >>><A, B>(_ function: (A) -> B, argument: A) -> B {
    return function(argument)
}

/**
 Performs function composition over two functions
 
 ```
 func lines(in input: String) -> [String] { ... }
 func countElements<T>(_ input: [T]) -> Int { ... }
 
 let input: String = ...
 let countLines = lines |> countElements
 let result = countLines(input)
 ```
 
 - returns: a function as composition of two given functions
 */
infix operator |>: ApplicativePrecedence
public func |><A, B, C>(_ lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}
