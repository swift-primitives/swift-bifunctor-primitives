// Bifunctor.Distributivity.swift
// Sub-namespace for the distributivity isomorphism between binary product
// and binary coproduct.

extension Bifunctor {
    /// The categorical distributivity law between binary product and binary
    /// coproduct: `A × (B + C) ≅ (A × B) + (A × C)`.
    ///
    /// Concrete realizations operate on `Pair` (binary product) and `Either`
    /// (binary coproduct) and cover both directions of the iso plus its
    /// symmetric form (the law applies on either arm of the product).
    ///
    /// ## Topics
    ///
    /// ### Forward direction
    /// - ``distribute(_:)-(consuming Pair<_, Either<_, _>>)``
    /// - ``distribute(_:)-(consuming Pair<Either<_, _>, _>)``
    ///
    /// ### Inverse direction
    /// - ``factor(_:)-(consuming Either<Pair<_, _>, Pair<_, _>>)``
    /// - ``factor(_:)-(consuming Either<Pair<_, _>, Pair<_, _>>)``
    public enum Distributivity: Sendable {}
}
