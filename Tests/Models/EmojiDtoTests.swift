//
//  EmojiDtoTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Foundation
import Testing
@testable import colir

@Suite("Emoji DTO Tests")
struct EmojiDtoTests {
    // MARK: - EmojisGroup Tests

    @Test("EmojisGroup has all expected cases")
    func emojisGroup_allCases() {
        let allCases = EmojisGroup.allCases

        #expect(allCases.contains(.people))
        #expect(allCases.contains(.nature))
        #expect(allCases.contains(.foods))
        #expect(allCases.contains(.places))
        #expect(allCases.contains(.activity))
        #expect(allCases.contains(.objects))
        #expect(allCases.contains(.symbols))
        #expect(allCases.contains(.flags))
        #expect(allCases.count == 8)
    }

    @Test("EmojisGroup name returns correct string")
    func emojisGroup_name() {
        #expect(EmojisGroup.people.name == "people")
        #expect(EmojisGroup.nature.name == "nature")
        #expect(EmojisGroup.foods.name == "foods")
        #expect(EmojisGroup.places.name == "places")
        #expect(EmojisGroup.activity.name == "activity")
        #expect(EmojisGroup.objects.name == "objects")
        #expect(EmojisGroup.symbols.name == "symbols")
        #expect(EmojisGroup.flags.name == "flags")
    }

    // MARK: - EmojiDto Decoding Tests

    @Test("EmojiDto decodes from JSON")
    func emojiDto_decodes() throws {
        let json = """
        {
            "group": 0,
            "hexcode": "1F600",
            "label": "grinning face",
            "order": 1,
            "tags": ["smile", "happy"],
            "unicode": "😀",
            "shortcodes": [":grinning:"],
            "emoticon": ":D",
            "skins": null
        }
        """

        let data = json.data(using: .utf8)!
        let emoji = try JSONDecoder().decode(EmojiDto.self, from: data)

        #expect(emoji.group == 0)
        #expect(emoji.hexcode == "1F600")
        #expect(emoji.label == "grinning face")
        #expect(emoji.order == 1)
        #expect(emoji.tags?.count == 2)
        #expect(emoji.unicode == "😀")
        #expect(emoji.shortcodes.count == 1)
    }

    @Test("EmojiDto decodes with minimal fields")
    func emojiDto_decodesMinimal() throws {
        let json = """
        {
            "hexcode": "1F600",
            "label": "grinning face",
            "unicode": "😀",
            "shortcodes": [":grinning:"]
        }
        """

        let data = json.data(using: .utf8)!
        let emoji = try JSONDecoder().decode(EmojiDto.self, from: data)

        #expect(emoji.hexcode == "1F600")
        #expect(emoji.label == "grinning face")
        #expect(emoji.group == nil)
        #expect(emoji.order == nil)
        #expect(emoji.tags == nil)
        #expect(emoji.emoticon == nil)
        #expect(emoji.skins == nil)
    }

    // MARK: - EmojiEmoticonDto Tests

    @Test("EmojiEmoticonDto decodes string")
    func emojiEmoticonDto_decodesString() throws {
        let json = "\":D\""
        let data = json.data(using: .utf8)!
        let emoticon = try JSONDecoder().decode(EmojiEmoticonDto.self, from: data)

        if case .string(let value) = emoticon {
            #expect(value == ":D")
        } else {
            Issue.record("Expected string case")
        }
    }

    @Test("EmojiEmoticonDto decodes string array")
    func emojiEmoticonDto_decodesStringArray() throws {
        let json = "[\":D\", \":)\", \"=)\"]"
        let data = json.data(using: .utf8)!
        let emoticon = try JSONDecoder().decode(EmojiEmoticonDto.self, from: data)

        if case .stringArray(let values) = emoticon {
            #expect(values.count == 3)
            #expect(values.contains(":D"))
            #expect(values.contains(":)"))
            #expect(values.contains("=)"))
        } else {
            Issue.record("Expected stringArray case")
        }
    }

    // MARK: - EmojiSkinDto Tests

    @Test("EmojiSkinDto decodes from JSON")
    func emojiSkinDto_decodes() throws {
        let json = """
        {
            "group": 1,
            "hexcode": "1F44B-1F3FB",
            "label": "waving hand: light skin tone",
            "order": 10,
            "unicode": "👋🏻"
        }
        """

        let data = json.data(using: .utf8)!
        let skin = try JSONDecoder().decode(EmojiSkinDto.self, from: data)

        #expect(skin.group == 1)
        #expect(skin.hexcode == "1F44B-1F3FB")
        #expect(skin.label == "waving hand: light skin tone")
        #expect(skin.order == 10)
        #expect(skin.unicode == "👋🏻")
    }

    // MARK: - EmojisListDto Tests

    @Test("EmojisListDto decodes from JSON")
    func emojisListDto_decodes() throws {
        let json = """
        {
            "people": [
                {
                    "hexcode": "1F600",
                    "label": "grinning face",
                    "unicode": "😀",
                    "shortcodes": [":grinning:"]
                }
            ],
            "nature": [],
            "foods": [],
            "places": [],
            "activity": [],
            "objects": [],
            "symbols": [],
            "flags": []
        }
        """

        let data = json.data(using: .utf8)!
        let list = try JSONDecoder().decode(EmojisListDto.self, from: data)

        #expect(list.people.count == 1)
        #expect(list.nature.isEmpty)
        #expect(list.foods.isEmpty)
    }

    @Test("EmojisListDto emojis(in:) returns correct group")
    func emojisListDto_emojisInGroup() throws {
        let json = """
        {
            "people": [
                {"hexcode": "1F600", "label": "a", "unicode": "😀", "shortcodes": ["a"]}
            ],
            "nature": [
                {"hexcode": "1F436", "label": "b", "unicode": "🐶", "shortcodes": ["b"]},
                {"hexcode": "1F431", "label": "c", "unicode": "🐱", "shortcodes": ["c"]}
            ],
            "foods": [],
            "places": [],
            "activity": [],
            "objects": [],
            "symbols": [],
            "flags": []
        }
        """

        let data = json.data(using: .utf8)!
        let list = try JSONDecoder().decode(EmojisListDto.self, from: data)

        #expect(list.emojis(in: .people).count == 1)
        #expect(list.emojis(in: .nature).count == 2)
        #expect(list.emojis(in: .foods).isEmpty)
    }

    // MARK: - EmojiDto with Skins Tests

    @Test("EmojiDto decodes with skin variations")
    func emojiDto_decodesWithSkins() throws {
        let json = """
        {
            "hexcode": "1F44B",
            "label": "waving hand",
            "unicode": "👋",
            "shortcodes": [":wave:"],
            "skins": [
                {
                    "group": 1,
                    "hexcode": "1F44B-1F3FB",
                    "label": "waving hand: light skin tone",
                    "order": 1,
                    "unicode": "👋🏻"
                },
                {
                    "group": 1,
                    "hexcode": "1F44B-1F3FC",
                    "label": "waving hand: medium-light skin tone",
                    "order": 2,
                    "unicode": "👋🏼"
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let emoji = try JSONDecoder().decode(EmojiDto.self, from: data)

        #expect(emoji.skins != nil)
        #expect(emoji.skins?.count == 2)
        #expect(emoji.skins?[0].unicode == "👋🏻")
        #expect(emoji.skins?[1].unicode == "👋🏼")
    }

    // MARK: - Edge Cases

    @Test("EmojiDto with empty shortcodes")
    func emojiDto_emptyShortcodes() throws {
        let json = """
        {
            "hexcode": "1F600",
            "label": "test",
            "unicode": "😀",
            "shortcodes": []
        }
        """

        let data = json.data(using: .utf8)!
        let emoji = try JSONDecoder().decode(EmojiDto.self, from: data)

        #expect(emoji.shortcodes.isEmpty)
    }

    @Test("EmojiDto with multiple shortcodes")
    func emojiDto_multipleShortcodes() throws {
        let json = """
        {
            "hexcode": "1F600",
            "label": "test",
            "unicode": "😀",
            "shortcodes": [":grin:", ":grinning:", ":smile:"]
        }
        """

        let data = json.data(using: .utf8)!
        let emoji = try JSONDecoder().decode(EmojiDto.self, from: data)

        #expect(emoji.shortcodes.count == 3)
    }
}
