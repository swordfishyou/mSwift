# mSwift
A simple eDSL introducing functional approach to pure calculations with `Optional` and `Array` types.

- [Functions](../Documentation/Functions.md)
- [Currying and partial application](../Documentation/Currying.md)
- Usage
    - Applicative
    - Binding

## Motivation
Functional languages like Haskell or Erlang have robust and clear syntax for pure computations. Such code is easy to understand, it's clear and doesn't break control flow. On a daily basis we don't perform pure computations, but when we do we write a lot of code. This small eDSL is designed to stay DRY in such cases.

### `Optional`
Swift's _optional binding_ and common usage often preferable for clarity and style. But `Optional` is a container type for a reason: it preserves specific context. The context is:
* it's OK for `Optional` value to absent,
* one doesn't use `Optional` for _error handling_.

`guard let` and `if let` force you to unwrap the box and handle the absence of a value. Moreover, so called _optional binding_ is implemented as conditional statement, so it breaks control flow.

### `Array`
We often use `Array` as a collection of objects, to keep some order, etc. Only on a rare occasion we use pure `Array` as designed: for _non-deterministic_ computations. 

Consider number `5`. It's a deterministic value, it has just one result and we know it's `5`. If we multiply it by another deterministic value like `3` we have another deterministic value `15`. All these numbers have only one result. On the onther hand array `[3, 5]` contains two elements and if we perform multiplication by another array `[1, 10, 100]` we have an array with even more elements `[3, 5, 30, 50, 300, 500]`. Now you can see that `Array` is also a container type like `Optional`. Like any container type it also preserves a context: 
* there might be multiple elements in a single `Array` value,
* the number of elements in a resulting `Array` may differ from initial values.

Since functional API is really handy we often prefer it over loops. Unfortunately, Swift lacks a number of robust sugar available in functional languages.

## Implementation
**mSwift** introduces currying and a set of operators influenced by Haskell in order to apply functions in a _pipeline_.


## Applicative

### apply
Syntax and notation is based on Haskell's `Applicative` type providing the same operator. So type's name is used for operator's `precedencegroup` 
```swift
precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: NilCoalescingPrecedence
}
```
Operator applies any optional function of type `(Wrapped) -> T` to a value wrapped into `Optional`
```swift
func <*><A, B>(_ transform: ((A) -> B)?, arg: A?) -> B? {
    return transform.flatMap { arg.map($0) }
}
```
### map
Map, alongside with _apply_ allows us non-optional functions application to multiple optional values. Consider a sum or a product of two optional integers. One can implement extensions, but beautiful and robust solution is using operator in `ApplicativePrecedence` group:
```swift
func <?><A, B>(_ function: (A) -> B, arg: A?) -> B? {
    return arg.map(function)
}
```
### bind
`guard let` and `if let` unwraps `Optional` and binds its value to a variable. That's not what functional binding really is. One can think of it like a functional composition for container types, that preserves container's context. In Haskell bind is introduced in `Monad` type  as `>>=` operator. In Swift this name is reserved for a default operator, that's why we name it `??=` since `?` is strongly related to `Optional`.

Operator's behavior motivates `precedencegroup` name
```swift
precedencegroup BindingPrecedence {
    associativity: left
    higherThan: ApplicativePrecedence
}
```

_bind_ operator applies optional function of type `(Wrapped) -> T?` to optional value, so it binds one `Optional` to another.
```swift
func ??=<A, B>(_ transform: ((A) -> B?)?, arg: A?) -> B? {
    return transform.flatMap { arg.flatMap($0) }
}
```

#### Arguments order
You may noticed that `precedencegroup`s have left associativity, but function comes as a first argument. This introduces a prefix application of a function like we regulary do but instead of bracers we have an operator: `f(x)` is replaced with `f <?> x`.

If we apply several operators in with the same precedence we can avoid bracers to let compiler understand what do we want.
