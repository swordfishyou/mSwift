# Currying
Function can take a different number of arguments. If we want to stay DRY we need a technique that allows us apply function of any arguments to any number of arguments. _Currying_ is such technique. 

Currying translates the evaluation of a function that takes multiple arguments into evaluating a sequence of functions, each with a single argument:
```swift
func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C
func curry<A, B, C, D>(_ function: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D
```

> Notice that `curry` takes an escaping closure as the argument. That's why we need supply pure static functions here in order to avoid retain cycles and memory leaks.

This way we can declare operators that take a function of a single argument `(A) -> B`. Here `B` may be another curried function. An operator applied just one argument to curried function and returned another function as the result. This is a case of _partial application_.

## Partial application
Partial application is strongly related to currying. If we supply fewer than total number of arguments that curried function takes, this is reffeded to as _partial application_. In general this process is a bit complex, but main motivation behind partial application remains the same: very often functions obtained this way are useful.