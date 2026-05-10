// Bifunctor.swift
// Namespace for categorical bifunctor structure.

/// Namespace for categorical bifunctor structure — operations on type
/// constructors that take two type parameters (binary products and coproducts).
///
/// `Bifunctor` opens a categorical-structure home distinct from value-level
/// algebra (`Algebra.Magma`, `Algebra.Semigroup`, `Algebra.Group`, …). The
/// distinction:
///
/// | Domain | Operates on | Examples |
/// |--------|-------------|----------|
/// | Value-level algebra | values of one carrier set | semigroup over `String` concatenation, monoid over `Int` addition |
/// | Type-level categorical structure | type constructors | binary product (`Pair`), binary coproduct (`Either`), distributivity laws between them |
///
/// ## Scope
///
/// As of 0.1.0, the package ships **distributivity** between the binary
/// product (`Pair`) and the binary coproduct (`Either`):
///
/// - ``Distributivity/distribute(_:)-(consuming Pair<_, Either<_, _>>)``
///   `Pair<A, Either<B, C>>` → `Either<Pair<A, B>, Pair<A, C>>`
/// - ``Distributivity/distribute(_:)-(consuming Pair<Either<_, _>, _>)``
///   `Pair<Either<A, B>, C>` → `Either<Pair<A, C>, Pair<B, C>>`
/// - ``Distributivity/factor(_:)-(consuming Either<Pair<_, _>, Pair<_, _>>)``
///   inverses
///
/// ## What this namespace is *not*
///
/// A `Bifunctor.Protocol` is deliberately not declared. Swift cannot express
/// a fully general bifunctor protocol — there are no parameterized
/// associated types (`associatedtype Mapped<NewFirst, NewSecond>`) and no
/// higher-kinded types. A marker-only protocol would carry no operations;
/// an endo-`bimap` protocol would be strictly weaker than the existing
/// concrete `Pair.map(first:second:)` and `Either.map(left:right:)` shapes.
/// Concrete operations at known type-constructor pairs are the right Swift
/// shape until the language acquires the necessary expressivity. See
/// `Research/bifunctor-primitives-package-home.md` for the full rationale.
public enum Bifunctor: Sendable {}
