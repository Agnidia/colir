//
//  Collection+SafeIndex.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 28.01.2025.
//  Copyright © 2025 IGR Software. All rights reserved.
//

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
