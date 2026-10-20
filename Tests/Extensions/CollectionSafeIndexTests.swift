//
//  CollectionSafeIndexTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import Testing
@testable import colir

@Suite("Collection Safe Index Extension")
struct CollectionSafeIndexTests {
    // MARK: - Array Tests

    @Test("Safe subscript returns element when index is valid")
    func safeSubscript_returnsElementInBounds() {
        let array = [1, 2, 3, 4, 5]

        #expect(array[safe: 0] == 1)
        #expect(array[safe: 2] == 3)
        #expect(array[safe: 4] == 5)
    }

    @Test("Safe subscript returns nil when index is negative")
    func safeSubscript_returnsNilForNegativeIndex() {
        let array = [1, 2, 3]

        // Note: Arrays use Int indices, and negative indices are not valid
        // The safe subscript checks indices.contains(index)
        // For arrays, valid indices are 0..<count
        #expect(array[safe: -1] == nil)
    }

    @Test("Safe subscript returns nil when index is out of bounds")
    func safeSubscript_returnsNilOutOfBounds() {
        let array = [1, 2, 3]

        #expect(array[safe: 3] == nil)
        #expect(array[safe: 100] == nil)
    }

    @Test("Safe subscript returns nil for empty collection")
    func safeSubscript_handlesEmptyCollection() {
        let emptyArray: [Int] = []

        #expect(emptyArray[safe: 0] == nil)
        #expect(emptyArray[safe: -1] == nil)
    }

    // MARK: - String Tests

    @Test("Safe subscript works with String indices")
    func safeSubscript_worksWithStrings() {
        let string = "Hello"

        #expect(string[safe: string.startIndex] == "H")
        #expect(string[safe: string.index(string.startIndex, offsetBy: 4)] == "o")
    }

    @Test("Safe subscript returns nil for invalid String index")
    func safeSubscript_stringInvalidIndex() {
        let string = "Hi"
        let invalidIndex = string.endIndex

        #expect(string[safe: invalidIndex] == nil)
    }

    // MARK: - Dictionary Tests

    @Test("Safe subscript works with Dictionary keys")
    func safeSubscript_worksWithDictionary() {
        let dict = ["a": 1, "b": 2, "c": 3]
        let keys = Array(dict.keys)

        // Dictionary is unordered, so we check all keys are accessible
        for key in keys {
            if let index = keys.firstIndex(of: key) {
                #expect(keys[safe: index] != nil)
            }
        }
    }

    // MARK: - Type Preservation Tests

    @Test("Safe subscript preserves element type")
    func safeSubscript_preservesType() {
        let strings = ["one", "two", "three"]
        let result: String? = strings[safe: 1]

        #expect(result == "two")
    }

    @Test("Safe subscript works with optional elements")
    func safeSubscript_worksWithOptionalElements() {
        let optionals: [Int?] = [1, nil, 3]

        #expect(optionals[safe: 0] == .some(1))
        #expect(optionals[safe: 1] == .some(nil))
        #expect(optionals[safe: 2] == .some(3))
        #expect(optionals[safe: 3] == nil)
    }

    // MARK: - Edge Cases

    @Test("Safe subscript works with single element collection")
    func safeSubscript_singleElement() {
        let single = [42]

        #expect(single[safe: 0] == 42)
        #expect(single[safe: 1] == nil)
    }

    @Test("Safe subscript works with custom types")
    func safeSubscript_customTypes() {
        struct Person: Equatable {
            let name: String
        }

        let people = [Person(name: "Alice"), Person(name: "Bob")]

        #expect(people[safe: 0] == Person(name: "Alice"))
        #expect(people[safe: 1] == Person(name: "Bob"))
        #expect(people[safe: 2] == nil)
    }
}
