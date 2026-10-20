//
//  EmojiSkinDto.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import Foundation

/// Enum defining various emoji groups.
enum EmojisGroup: CaseIterable {
    case people
    case nature
    case foods
    case places
    case activity
    case objects
    case symbols
    case flags

    var name: String {
        String(describing: self)
    }
}

/// Struct representing a list of emojis categorized by different groups.
struct EmojisListDto: Decodable {
    let people, nature, foods, places, activity, objects, symbols, flags: [EmojiDto]

    /// Returns the list of emojis for a given group.
    /// - Parameter group: The `EmojisGroup` for which emojis are required.
    /// - Returns: An array of `EmojiDto` for the specified group.
    func emojis(in group: EmojisGroup) -> [EmojiDto] {
        switch group {
        case .people: people
        case .nature: nature
        case .foods: foods
        case .places: places
        case .activity: activity
        case .objects: objects
        case .symbols: symbols
        case .flags: flags
        }
    }
}

/// Struct representing an individual emoji with various attributes.
struct EmojiDto: Decodable {
    let group: Int?
    let hexcode, label: String
    let order: Int?
    let tags: [String]?
    let unicode: String
    let shortcodes: [String]
    let emoticon: EmojiEmoticonDto?
    let skins: [EmojiSkinDto]?
}

/// Enum representing the emoticon of an emoji, which can be a single string or an array of strings.
enum EmojiEmoticonDto: Decodable {
    case string(String)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([String].self) {
            self = .stringArray(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.typeMismatch(EmojiEmoticonDto.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected a string or an array of strings for EmojiEmoticonDto"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .stringArray(let values):
            try container.encode(values)
        }
    }
}

/// Struct representing the skin variations of an emoji.
struct EmojiSkinDto: Decodable {
    let group: Int
    let hexcode, label: String
    let order: Int
    let unicode: String
}
