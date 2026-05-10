# ``Bifunctor_Primitives``

@Metadata {
    @DisplayName("Bifunctor Primitives")
    @TitleHeading("Swift Primitives")
}

Categorical bifunctor structure for Swift — distributivity isos between the
binary product (``Pair``) and the binary coproduct (``Either``).

## Overview

`Bifunctor` opens a categorical-structure home in the institute's primitives
catalog, distinct from value-level algebra (`Algebra.Magma`,
`Algebra.Semigroup`, `Algebra.Group`, …). Where value-level algebra operates
on values of one carrier set, bifunctor structure operates on type
constructors that take two type parameters — `Pair<First, Second>` (the
binary categorical product) and `Either<Left, Right>` (the binary categorical
coproduct).

The 0.1.0 surface is **distributivity** — the iso

```
A × (B + C)  ≅  (A × B) + (A × C)
```

realized concretely as ``Bifunctor/Distributivity/distribute(_:)-(consuming Pair<_, Either<_, _>>)``
and its inverse ``Bifunctor/Distributivity/factor(_:)-(consuming Either<Pair<_, _>, Pair<_, _>>)``,
plus the symmetric forms that operate on the first arm of the product.

## Why a separate micro-package

Two design-space distinctions place categorical-structure content in its own
home:

- **Versus value-level algebra.** `Algebra.Semigroup`, `Algebra.Monoid`,
  `Algebra.Group`, … operate on a single carrier set with associative,
  identity-bearing, or invertible operations on its values.
  Bifunctor structure operates on the *type constructors* themselves;
  conflating the two would mission-creep either home.

- **Versus the type-parameter packages.** `swift-pair-primitives` and
  `swift-either-primitives` stay orthogonal sibling peers — neither
  depends on the other. The bridge content (Pair × Either distributivity)
  depends downward on both, so it lives one tier up the categorical-structure
  axis. Hosting the bridge in either sibling would create a dep cycle or
  break the package symmetry.

## What is *not* declared

A `Bifunctor.Protocol` is deliberately not declared. Swift cannot express a
fully general bifunctor protocol: there are no parameterized associated
types (`associatedtype Mapped<NewFirst, NewSecond>`) and no higher-kinded
types. A marker-only protocol carries no operations; an endo-`bimap` protocol
is strictly weaker than the existing concrete `Pair.map(first:second:)` and
`Either.map(left:right:)`. Concrete operations at known type-constructor
pairs are the right Swift shape today. See
`Research/bifunctor-primitives-package-home.md` for the rationale.

## Topics

### Namespaces

- ``Bifunctor``
- ``Bifunctor/Distributivity``

### Distributivity over Pair × Either

- ``Bifunctor/Distributivity/distribute(_:)-(consuming Pair<_, Either<_, _>>)``
- ``Bifunctor/Distributivity/distribute(_:)-(consuming Pair<Either<_, _>, _>)``
- ``Bifunctor/Distributivity/factor(_:)-(consuming Either<Pair<_, _>, Pair<_, _>>)``
