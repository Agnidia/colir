//
//  EmojisManager.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.09.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
import AppKit

class EmojisManager {
    
    private lazy var emojisList: EmojisListDto? = {
        var list: EmojisListDto? = nil
        
        guard let asset = NSDataAsset(name: "emojibase") else {
            assert(false, "missed emojibase")
            return list
        }
        
        do {
            list = try JSONDecoder().decode(EmojisListDto.self, from: asset.data)
        } catch {
            assert(false, "unable to parse emojis")
        }
        
        return list
    }()
    
    var emojis: [EmojisGroup: [Character]] {
        guard let emojisList else {
            assert(false, "missed emojibase")
            return [:]
        }
        
        var list: [EmojisGroup: [Character]] = .init()
        for group in EmojisGroup.allCases {
            list[group] = emojisList.emojis(in: group).reduce(into: [Character]()) { list, emoji in
                list.append(Character(emoji.unicode))
                if let skins = emoji.skins {
                    list.append(contentsOf: skins.map({ Character($0.unicode) }))
                }
            }
            
        }
        
        return list
    }
}
