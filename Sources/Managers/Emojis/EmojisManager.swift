//
//  EmojisManager.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import Foundation

/// A manager class for handling emojis loaded from a JSON asset.
final class EmojisManager {
    private lazy var emojisList: EmojisListDto? = {
        var list: EmojisListDto? = nil

        // Load and decode the emojis from the NSDataAsset.
        guard let asset = NSDataAsset(name: "emojibase") else {
            assertionFailure("Missing emojibase asset")
            return list
        }

        do {
            list = try JSONDecoder().decode(EmojisListDto.self, from: asset.data)
        } catch {
            assertionFailure("Unable to parse emojis: \(error.localizedDescription)")
        }

        return list
    }()

    /// A dictionary mapping emoji groups to arrays of characters.
    /// - Returns: A dictionary where each key is an `EmojisGroup`, and each value is an array of `Character` representing emojis in that group.
    var emojis: [EmojisGroup: [Character]] {
        guard let emojisList else {
            assertionFailure("Missing emojibase asset")
            return [:]
        }

        var list: [EmojisGroup: [Character]] = .init()

        // Populate the dictionary with emojis grouped by `EmojisGroup`.
        for group in EmojisGroup.allCases {
            list[group] = emojisList.emojis(in: group).reduce(into: [Character]()) { list, emoji in
                list.append(Character(emoji.unicode))
                if let skins = emoji.skins {
                    list.append(contentsOf: skins.map { Character($0.unicode) })
                }
            }
        }

        return list
    }
}
