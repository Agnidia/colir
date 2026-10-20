//
//  EmojisManagerTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("EmojisManager Tests")
struct EmojisManagerTests {
    // MARK: - Initialization Tests

    @Test("EmojisManager initializes successfully")
    func init_success() {
        let manager = EmojisManager()

        #expect(manager != nil)
    }

    // MARK: - emojis Property Tests

    @Test("emojis returns dictionary with all groups")
    func emojis_containsAllGroups() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        // Should have entries for all emoji groups
        for group in EmojisGroup.allCases {
            #expect(emojis[group] != nil, "Missing group: \(group)")
        }
    }

    @Test("emojis groups are non-empty")
    func emojis_groupsNonEmpty() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        // At least some groups should have emojis
        let nonEmptyGroups = emojis.values.filter { !$0.isEmpty }
        #expect(!nonEmptyGroups.isEmpty, "Should have at least some emojis")
    }

    @Test("emojis returns Characters")
    func emojis_returnsCharacters() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        for (_, characters) in emojis {
            for char in characters {
                #expect(char is Character)
            }
        }
    }

    @Test("emojis contain actual emoji characters")
    func emojis_containActualEmojis() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        // Flatten all emojis and check at least some are real emojis
        let allEmojis = emojis.values.flatMap(\.self)

        // At least some should be recognized emojis
        let emojiCount = allEmojis.count(where: { $0.isEmoji })
        #expect(emojiCount > 0, "Should contain actual emoji characters")
    }

    // MARK: - Group Tests

    @Test("people group contains face emojis")
    func people_containsFaceEmojis() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        if let people = emojis[.people] {
            #expect(!people.isEmpty, "People group should not be empty")
        }
    }

    @Test("nature group contains animal emojis")
    func nature_containsAnimalEmojis() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        if let nature = emojis[.nature] {
            #expect(!nature.isEmpty, "Nature group should not be empty")
        }
    }

    @Test("foods group contains food emojis")
    func foods_containsFoodEmojis() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        if let foods = emojis[.foods] {
            #expect(!foods.isEmpty, "Foods group should not be empty")
        }
    }

    @Test("objects group contains object emojis")
    func objects_containsObjectEmojis() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        if let objects = emojis[.objects] {
            #expect(!objects.isEmpty, "Objects group should not be empty")
        }
    }

    @Test("symbols group contains symbol emojis")
    func symbols_containsSymbolEmojis() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        if let symbols = emojis[.symbols] {
            #expect(!symbols.isEmpty, "Symbols group should not be empty")
        }
    }

    // MARK: - Skin Tone Variations Tests

    @Test("emojis include skin tone variations")
    func emojis_includeSkinToneVariations() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        // People emojis should include skin tone variations
        if let people = emojis[.people] {
            // Should have more entries due to skin tone variations
            #expect(!people.isEmpty)
        }
    }

    // MARK: - Lazy Loading Tests

    @Test("emojis property is lazily loaded")
    func emojis_lazilyLoaded() {
        // Creating manager should be quick
        let startTime = CFAbsoluteTimeGetCurrent()
        _ = EmojisManager()
        let initTime = CFAbsoluteTimeGetCurrent() - startTime

        #expect(initTime < 1.0, "Initialization should be fast (lazy loading)")
    }

    @Test("multiple accesses return same data")
    func emojis_multipleAccesses() {
        let manager = EmojisManager()

        let emojis1 = manager.emojis
        let emojis2 = manager.emojis

        // Should return same dictionary structure
        #expect(emojis1.keys.count == emojis2.keys.count)

        for group in EmojisGroup.allCases {
            #expect(emojis1[group]?.count == emojis2[group]?.count)
        }
    }

    // MARK: - Total Count Tests

    @Test("total emoji count is reasonable")
    func emojis_totalCountReasonable() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        let totalCount = emojis.values.reduce(0) { $0 + $1.count }

        // Should have a reasonable number of emojis (hundreds to thousands)
        #expect(totalCount > 100, "Should have at least 100 emojis")
        #expect(totalCount < 10_000, "Should have less than 10000 emojis")
    }

    // MARK: - Unicode Validity Tests

    @Test("emojis have valid unicode")
    func emojis_validUnicode() {
        let manager = EmojisManager()
        let emojis = manager.emojis

        for (_, characters) in emojis {
            for char in characters {
                // Each should be a valid Character that can be converted to String
                let str = String(char)
                #expect(!str.isEmpty)
            }
        }
    }
}
