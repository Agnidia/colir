//
//  Collection+SafeIndex.swift
//
//  Created on 29.01.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
