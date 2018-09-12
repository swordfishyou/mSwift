import Foundation
/// Curries a function of two arguments
public func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { argA in { argB in function(argA, argB) } }
}
/// Curries a function of three arguments
public func curry<A, B, C, D>(_ function: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { argA in { argB in { argC in function(argA, argB, argC) } } }
}
/// Curries a function of four arguments
public func curry<A, B, C, D, E>(_ function: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
    return { argA in { argB in { argC in { argD in function(argA, argB, argC, argD) } } } }
}
