// Bifunctor.Distributivity Tests.swift
//
// Distributivity iso between Pair (binary product) and Either (binary
// coproduct): A × (B + C) ≅ (A × B) + (A × C).
//
// Tests cover both forward overloads (`distribute`), both inverse
// overloads (`factor`), and the round-trip identities that witness the
// iso. Pair and Either are checked for equality using their stdlib
// `Equatable` conformances (Copyable arms).

import Testing

@testable import Bifunctor_Primitives

extension Bifunctor.Distributivity {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

// MARK: - Unit: distribute (Either-in-second)

extension Bifunctor.Distributivity.Test.Unit {

    @Test
    func `distribute Pair<A, Either<B, C>> with .left routes to .left(Pair<A, B>)`() {
        let pair: Pair<Int, Either<String, Bool>> = Pair(42, .left("hello"))
        let result = Bifunctor.Distributivity.distribute(pair)
        let expected: Either<Pair<Int, String>, Pair<Int, Bool>> = .left(Pair(42, "hello"))
        #expect(result == expected)
    }

    @Test
    func `distribute Pair<A, Either<B, C>> with .right routes to .right(Pair<A, C>)`() {
        let pair: Pair<Int, Either<String, Bool>> = Pair(42, .right(true))
        let result = Bifunctor.Distributivity.distribute(pair)
        let expected: Either<Pair<Int, String>, Pair<Int, Bool>> = .right(Pair(42, true))
        #expect(result == expected)
    }
}

// MARK: - Unit: distribute (Either-in-first)

extension Bifunctor.Distributivity.Test.Unit {

    @Test
    func `distribute Pair<Either<A, B>, C> with .left routes to .left(Pair<A, C>)`() {
        let pair: Pair<Either<Int, String>, Bool> = Pair(.left(42), true)
        let result = Bifunctor.Distributivity.distribute(pair)
        let expected: Either<Pair<Int, Bool>, Pair<String, Bool>> = .left(Pair(42, true))
        #expect(result == expected)
    }

    @Test
    func `distribute Pair<Either<A, B>, C> with .right routes to .right(Pair<B, C>)`() {
        let pair: Pair<Either<Int, String>, Bool> = Pair(.right("hi"), true)
        let result = Bifunctor.Distributivity.distribute(pair)
        let expected: Either<Pair<Int, Bool>, Pair<String, Bool>> = .right(Pair("hi", true))
        #expect(result == expected)
    }
}

// MARK: - Unit: factor (inverse of Either-in-second)

extension Bifunctor.Distributivity.Test.Unit {

    @Test
    func `factor Either<Pair<A, B>, Pair<A, C>> with .left routes to Pair<A, .left(B)>`() {
        let either: Either<Pair<Int, String>, Pair<Int, Bool>> = .left(Pair(42, "hello"))
        let result = Bifunctor.Distributivity.factor(either)
        let expected: Pair<Int, Either<String, Bool>> = Pair(42, .left("hello"))
        #expect(result == expected)
    }

    @Test
    func `factor Either<Pair<A, B>, Pair<A, C>> with .right routes to Pair<A, .right(C)>`() {
        let either: Either<Pair<Int, String>, Pair<Int, Bool>> = .right(Pair(42, true))
        let result = Bifunctor.Distributivity.factor(either)
        let expected: Pair<Int, Either<String, Bool>> = Pair(42, .right(true))
        #expect(result == expected)
    }
}

// MARK: - Unit: factor (inverse of Either-in-first)

extension Bifunctor.Distributivity.Test.Unit {

    @Test
    func `factor Either<Pair<A, C>, Pair<B, C>> with .left routes to Pair<.left(A), C>`() {
        let either: Either<Pair<Int, Bool>, Pair<String, Bool>> = .left(Pair(42, true))
        let result = Bifunctor.Distributivity.factor(either)
        let expected: Pair<Either<Int, String>, Bool> = Pair(.left(42), true)
        #expect(result == expected)
    }

    @Test
    func `factor Either<Pair<A, C>, Pair<B, C>> with .right routes to Pair<.right(B), C>`() {
        let either: Either<Pair<Int, Bool>, Pair<String, Bool>> = .right(Pair("hi", true))
        let result = Bifunctor.Distributivity.factor(either)
        let expected: Pair<Either<Int, String>, Bool> = Pair(.right("hi"), true)
        #expect(result == expected)
    }
}

// MARK: - Integration: round-trip identity (factor ∘ distribute = id)

extension Bifunctor.Distributivity.Test.Integration {

    @Test
    func `factor of distribute is identity (Either-in-second, .left start)`() {
        let original: Pair<Int, Either<String, Bool>> = Pair(42, .left("hello"))
        let roundTrip = Bifunctor.Distributivity.factor(
            Bifunctor.Distributivity.distribute(original)
        )
        #expect(roundTrip == original)
    }

    @Test
    func `factor of distribute is identity (Either-in-second, .right start)`() {
        let original: Pair<Int, Either<String, Bool>> = Pair(42, .right(true))
        let roundTrip = Bifunctor.Distributivity.factor(
            Bifunctor.Distributivity.distribute(original)
        )
        #expect(roundTrip == original)
    }

    @Test
    func `factor of distribute is identity (Either-in-first, .left start)`() {
        let original: Pair<Either<Int, String>, Bool> = Pair(.left(42), true)
        let roundTrip = Bifunctor.Distributivity.factor(
            Bifunctor.Distributivity.distribute(original)
        )
        #expect(roundTrip == original)
    }

    @Test
    func `factor of distribute is identity (Either-in-first, .right start)`() {
        let original: Pair<Either<Int, String>, Bool> = Pair(.right("hi"), true)
        let roundTrip = Bifunctor.Distributivity.factor(
            Bifunctor.Distributivity.distribute(original)
        )
        #expect(roundTrip == original)
    }
}

// MARK: - Integration: round-trip identity (distribute ∘ factor = id)

extension Bifunctor.Distributivity.Test.Integration {

    @Test
    func `distribute of factor is identity (Either-in-second, .left start)`() {
        let original: Either<Pair<Int, String>, Pair<Int, Bool>> = .left(Pair(42, "hello"))
        let roundTrip = Bifunctor.Distributivity.distribute(
            Bifunctor.Distributivity.factor(original)
        )
        #expect(roundTrip == original)
    }

    @Test
    func `distribute of factor is identity (Either-in-second, .right start)`() {
        let original: Either<Pair<Int, String>, Pair<Int, Bool>> = .right(Pair(42, true))
        let roundTrip = Bifunctor.Distributivity.distribute(
            Bifunctor.Distributivity.factor(original)
        )
        #expect(roundTrip == original)
    }

    @Test
    func `distribute of factor is identity (Either-in-first, .left start)`() {
        let original: Either<Pair<Int, Bool>, Pair<String, Bool>> = .left(Pair(42, true))
        let roundTrip = Bifunctor.Distributivity.distribute(
            Bifunctor.Distributivity.factor(original)
        )
        #expect(roundTrip == original)
    }

    @Test
    func `distribute of factor is identity (Either-in-first, .right start)`() {
        let original: Either<Pair<Int, Bool>, Pair<String, Bool>> = .right(Pair("hi", true))
        let roundTrip = Bifunctor.Distributivity.distribute(
            Bifunctor.Distributivity.factor(original)
        )
        #expect(roundTrip == original)
    }
}

// MARK: - Edge Case: Never elimination

extension Bifunctor.Distributivity.Test.`Edge Case` {

    @Test
    func `distribute over Either<B, Never> always yields .left`() {
        let pair: Pair<Int, Either<String, Never>> = Pair(42, .left("only"))
        let result = Bifunctor.Distributivity.distribute(pair)
        let expected: Either<Pair<Int, String>, Pair<Int, Never>> = .left(Pair(42, "only"))
        #expect(result == expected)
    }

    @Test
    func `distribute over Either<Never, C> always yields .right`() {
        let pair: Pair<Int, Either<Never, Bool>> = Pair(42, .right(true))
        let result = Bifunctor.Distributivity.distribute(pair)
        let expected: Either<Pair<Int, Never>, Pair<Int, Bool>> = .right(Pair(42, true))
        #expect(result == expected)
    }
}
