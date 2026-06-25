// Bifunctor.Distributivity+Pair.Either.swift
// Concrete realization of the categorical distributivity law
//
//     A × (B + C) ≅ (A × B) + (A × C)
//
// for the binary product `Pair` and the binary coproduct `Either`.
//
// Both directions of the iso ship: `distribute` (forward) and `factor`
// (inverse). The law applies on either arm of the product, so each
// direction has two overloads — discriminated by which Pair-arm holds the
// Either. All four operations admit `~Copyable & ~Escapable` arms; result
// lifetime is anchored to the consumed input via `@_lifetime(copy …)`.
//
// The mechanism mirrors `Pair`'s `apply` / `swapped` and `Either`'s
// `swapped`: direct field access on the consuming parameter, switch on the
// inner enum, rebuild the result. Each value flows through exactly one
// branch — no `~Copyable` value is duplicated, so no `Copyable`
// requirement is needed on any arm. The "factor requires `A: Copyable`"
// folklore applies to the round-trip *equation* `factor ∘ distribute = id`
// when the Pair-side `A` is observed by both produced arms; it does not
// apply to the operations themselves.

// MARK: - Forward: distribute

extension Bifunctor.Distributivity {

    /// Distributes a coproduct nested in the second arm of a product:
    /// `Pair<A, Either<B, C>>` → `Either<Pair<A, B>, Pair<A, C>>`.
    ///
    /// The categorical statement is `A × (B + C) ≅ (A × B) + (A × C)`. This
    /// overload realizes the iso when the coproduct sits on the right of
    /// the product.
    ///
    /// All three arms admit `~Copyable & ~Escapable`. Each value flows
    /// through exactly one branch of the match; no value is duplicated.
    ///
    /// ```swift
    /// let pair: Pair<Int, Either<String, Bool>> = Pair(42, .left("hi"))
    /// let result = Bifunctor.Distributivity.distribute(pair)
    /// // .left(Pair(42, "hi"))
    /// ```
    @inlinable
    @_lifetime(copy pair)
    public static func distribute<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<A, Either<B, C>>
    ) -> Either<Pair<A, B>, Pair<A, C>> {
        switch consume pair.second {
        case .left(let b):
            return .left(Pair<A, B>(pair.first, b))

        case .right(let c):
            return .right(Pair<A, C>(pair.first, c))
        }
    }

    /// Distributes a coproduct nested in the first arm of a product:
    /// `Pair<Either<A, B>, C>` → `Either<Pair<A, C>, Pair<B, C>>`.
    ///
    /// The symmetric form of ``distribute(_:)-(consuming Pair<_, Either<_, _>>)``,
    /// realizing the same iso when the coproduct sits on the left of the
    /// product.
    ///
    /// ```swift
    /// let pair: Pair<Either<Int, String>, Bool> = Pair(.left(42), true)
    /// let result = Bifunctor.Distributivity.distribute(pair)
    /// // .left(Pair(42, true))
    /// ```
    @inlinable
    @_lifetime(copy pair)
    public static func distribute<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<Either<A, B>, C>
    ) -> Either<Pair<A, C>, Pair<B, C>> {
        switch consume pair.first {
        case .left(let a):
            return .left(Pair<A, C>(a, pair.second))

        case .right(let b):
            return .right(Pair<B, C>(b, pair.second))
        }
    }
}

// MARK: - Inverse: factor

extension Bifunctor.Distributivity {

    /// Factors a coproduct of products into a product with a coproduct in
    /// the second arm: `Either<Pair<A, B>, Pair<A, C>>` → `Pair<A, Either<B, C>>`.
    ///
    /// The inverse of ``distribute(_:)-(consuming Pair<_, Either<_, _>>)``.
    /// All three arms admit `~Copyable & ~Escapable`; the `A` value flows
    /// through exactly one branch of the match (the inhabited one), so no
    /// duplication is required.
    ///
    /// ```swift
    /// let either: Either<Pair<Int, String>, Pair<Int, Bool>> = .left(Pair(42, "hi"))
    /// let result = Bifunctor.Distributivity.factor(either)
    /// // Pair(42, .left("hi"))
    /// ```
    @inlinable
    @_lifetime(copy either)
    public static func factor<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ either: consuming Either<Pair<A, B>, Pair<A, C>>
    ) -> Pair<A, Either<B, C>> {
        // Forwarding through case-specific helpers keeps the Pair-destructuring
        // body inside a *consuming-parameter* scope, which is the only context
        // where the move-checker reliably tracks partial consumption of two
        // fields of a ~Copyable struct (the let-binding inside a switch case
        // triggers a known move-checker bug: "copy of noncopyable typed value").
        // See `Pair.swift:97-98` in `swift-pair-primitives` for the same note.
        switch consume either {
        case .left(let pairAB):
            return Self._packLeftSecond(pairAB)

        case .right(let pairAC):
            return Self._packRightSecond(pairAC)
        }
    }

    /// Factors a coproduct of products into a product with a coproduct in
    /// the first arm: `Either<Pair<A, C>, Pair<B, C>>` → `Pair<Either<A, B>, C>`.
    ///
    /// The inverse of ``distribute(_:)-(consuming Pair<Either<_, _>, _>)``.
    /// The shared-second-arm `C` flows through exactly one branch of the
    /// match.
    ///
    /// ```swift
    /// let either: Either<Pair<Int, Bool>, Pair<String, Bool>> = .left(Pair(42, true))
    /// let result = Bifunctor.Distributivity.factor(either)
    /// // Pair(.left(42), true)
    /// ```
    @inlinable
    @_lifetime(copy either)
    public static func factor<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ either: consuming Either<Pair<A, C>, Pair<B, C>>
    ) -> Pair<Either<A, B>, C> {
        switch consume either {
        case .left(let pairAC):
            return Self._packLeftFirst(pairAC)

        case .right(let pairBC):
            return Self._packRightFirst(pairBC)
        }
    }
}

// MARK: - Pair-destructuring helpers (consuming-parameter scope)
//
// These four package-private helpers exist solely to give the
// Pair-destructuring body a consuming-parameter scope. The move-checker
// reliably tracks partial consumption of struct fields when the carrier
// is a function parameter declared `consuming`; it does not yet do so
// for `let`-bindings introduced by a switch case (move-checker bug:
// "copy of noncopyable typed value"). Forwarding through these helpers
// keeps `factor`'s body free of the bug while admitting full
// `~Copyable & ~Escapable` arm support.

extension Bifunctor.Distributivity {

    @inlinable
    @_lifetime(copy pair)
    internal static func _packLeftSecond<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<A, B>
    ) -> Pair<A, Either<B, C>> {
        Pair<A, Either<B, C>>(pair.first, .left(pair.second))
    }

    @inlinable
    @_lifetime(copy pair)
    internal static func _packRightSecond<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<A, C>
    ) -> Pair<A, Either<B, C>> {
        Pair<A, Either<B, C>>(pair.first, .right(pair.second))
    }

    @inlinable
    @_lifetime(copy pair)
    internal static func _packLeftFirst<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<A, C>
    ) -> Pair<Either<A, B>, C> {
        Pair<Either<A, B>, C>(.left(pair.first), pair.second)
    }

    @inlinable
    @_lifetime(copy pair)
    internal static func _packRightFirst<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<B, C>
    ) -> Pair<Either<A, B>, C> {
        Pair<Either<A, B>, C>(.right(pair.first), pair.second)
    }
}
