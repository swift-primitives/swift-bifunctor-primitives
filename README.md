# swift-bifunctor-primitives

Categorical bifunctor structure for Swift — distributivity isos between the
binary product (`Pair`) and the binary coproduct (`Either`).

## Quick Start

```swift
import Bifunctor_Primitives

// Pair<A, Either<B, C>>  →  Either<Pair<A, B>, Pair<A, C>>
let pair: Pair<Int, Either<String, Bool>> = Pair(42, .left("hello"))
let distributed = Bifunctor.Distributivity.distribute(pair)
// .left(Pair(42, "hello"))

// Inverse: Either<Pair<A, B>, Pair<A, C>>  →  Pair<A, Either<B, C>>
let either: Either<Pair<Int, String>, Pair<Int, Bool>> = .left(Pair(42, "hello"))
let factored = Bifunctor.Distributivity.factor(either)
// Pair(42, .left("hello"))
```

## Installation

```swift
.package(url: "https://github.com/swift-primitives/swift-bifunctor-primitives.git", branch: "main"),
```

```swift
.target(
    name: "MyTarget",
    dependencies: [
        .product(name: "Bifunctor Primitives", package: "swift-bifunctor-primitives"),
    ]
),
```

## Scope

The 0.1.0 surface is the distributivity law `A × (B + C) ≅ (A × B) + (A × C)`
realized for `Pair × Either`:

| Direction | Signature |
|-----------|-----------|
| Distribute (Either-in-second) | `Pair<A, Either<B, C>> → Either<Pair<A, B>, Pair<A, C>>` |
| Distribute (Either-in-first) | `Pair<Either<A, B>, C> → Either<Pair<A, C>, Pair<B, C>>` |
| Factor (inverse of first) | `Either<Pair<A, B>, Pair<A, C>> → Pair<A, Either<B, C>>` |
| Factor (inverse of second) | `Either<Pair<A, C>, Pair<B, C>> → Pair<Either<A, B>, C>` |

All four operate on `~Copyable & ~Escapable` arms.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
