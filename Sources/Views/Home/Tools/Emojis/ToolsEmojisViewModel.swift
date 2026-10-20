//
//  ToolsEmojisViewModel.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftCommons
import SwiftUI

/// A view model that provides data and state management for displaying emoji groups in `ToolsEmojisView`.
///
/// It manages the list of emoji groups, their emojis, and the current state of selected and expanded items. It also calculates the layout for displaying emojis in a grid.
final class ToolsEmojisViewModel: ObservableObject, DomainViewConstantProtocol {
    /// Type alias for domain-specific constants.
    typealias DomainViewConstantType = ToolsEmojisViewDomain

    /// View settings used for configuring the appearance of the view.
    let viewSettings: ToolsEmojisViewDomain = .init()

    /// Manager responsible for handling emojis data.
    private let emojisManager: EmojisManager = .init()

    /// List of emoji groups available.
    var groups: [EmojisGroup] = EmojisGroup.allCases

    /// Dictionary mapping each group to its associated emojis.
    var emojis: [EmojisGroup: [Character]]

    /// The currently selected emoji.
    @Published var selectedEmoji: Character? = nil

    /// Set of currently expanded emoji groups.
    @Published var expanded: Set<EmojisGroup> = []

    /// Width for each column in the grid layout.
    let columnWidth: CGFloat = 128

    /// Font size for the emojis, calculated as a fraction of the column width.
    var fontSize: CGFloat {
        columnWidth * 0.6
    }

    /// Corner radius for the emoji cells, configured via view settings.
    lazy var cellCornerRadius: CGFloat = viewSettings.cornerRadius!

    /// Initializes the view model with an optional dictionary of emojis.
    /// - Parameter emojis: Optional dictionary of emojis to override default emojis.
    init(emojis: [EmojisGroup: [Character]]? = nil) {
        self.emojis = emojis ?? emojisManager.emojis

        // Expand the first group by default if available
        if let firstGroup = groups.first {
            expanded.insert(firstGroup)
        }
    }

    /// Calculates the layout of columns for the grid based on the available width.
    /// - Parameter geometry: The geometry proxy used to get the available width.
    /// - Returns: An array of `GridItem` representing the grid layout.
    func columns(in geometry: GeometryProxy) -> [GridItem] {
        // Calculate the number of columns dynamically
        let magicWidthOffset = columnWidth * 0.25
        let width = geometry.size.width
        let spacing: CGFloat = viewSettings.spacing ?? .spacingDefault

        let columns = Int(width / (columnWidth + magicWidthOffset + spacing))
        let numberOfColumns = (CGFloat(columns) * columnWidth + CGFloat(columns) * spacing) > width ? columns - 1 : columns

        let gridLayout = Array(repeating: GridItem(.adaptive(minimum: columnWidth + magicWidthOffset), spacing: spacing), count: max(numberOfColumns, 1))

        return gridLayout
    }
}

extension ToolsEmojisViewModel {
    /// Preview instance for use in SwiftUI previews.
    static var preview: ToolsEmojisViewModel {
        ToolsEmojisViewModel()
    }
}
