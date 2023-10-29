//
//  EmojiDto.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.09.2023.
//

import Foundation

enum EmojisGroup: CaseIterable {
    case people, nature, foods, places, activity, objects, symbols, flags
    static var allCases: [EmojisGroup] = [people, nature, foods, places, activity, objects, symbols, flags]
}

extension EmojisGroup {
    var name: String {
        String(describing: self)
    }
}

extension EmojisGroup: Hashable {
}

// MARK: - EmojisListDto
struct EmojisListDto: Decodable {
    let people, nature, foods, places, activity, objects, symbols, flags: [EmojiDto]
}

extension EmojisListDto {
    func emojis(in group: EmojisGroup) -> [EmojiDto] {
        switch group {
        case .people:
            return people
        case .nature:
            return nature
        case .foods:
            return foods
        case .places:
            return places
        case .activity:
            return activity
        case .objects:
            return objects
        case .symbols:
            return symbols
        case .flags:
            return flags
        }
    }
}

// MARK: - Activity
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

enum EmojiEmoticonDto: Decodable {
    case string(String)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(EmojiEmoticonDto.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Emoticon"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - EmojiDto
struct EmojiSkinDto: Decodable {
    let group: Int
    let hexcode, label: String
    let order: Int
    let unicode: String
}
