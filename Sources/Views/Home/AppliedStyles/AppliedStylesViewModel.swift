//
//  AppliedStylesViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftCommons
import SwiftUI

/// ViewModel for managing and displaying applied styles.
///
/// The `AppliedStylesViewModel` class conforms to `ObservableObject` and is responsible for
/// managing the state and data related to applied styles. It also handles interactions with
/// other view models such as color, photo, picture, and emoji tools.
///
/// - Conforms to: `DomainViewConstantProtocol`
/// - Published Properties:
///   - `state`: The current state of the image.
///   - `data`: An array of `CustomizationTagViewData` used to display tags in the view.
/// - Methods:
///   - `update(state:imageCustomization:)`: Updates the view model with new state and customization data.
///
/// - EnvironmentObject:
///   - Uses various tool view models to manage different aspects of the applied styles.
@Observable
final class AppliedStylesViewModel: DomainViewConstantProtocol {
    // MARK: - DomainViewConstantProtocol

    typealias DomainViewConstantType = AppliedStylesViewDomain
    var viewSettings: DomainViewConstantType = .init()

    private var toolsColorsViewModel: ToolsColorsViewModel?
    private var toolsPhotosViewModel: ToolsPhotosViewModel?
    private var toolsPicturesViewModel: ToolsPicturesViewModel?
    private var toolsEmojisViewModel: ToolsEmojisViewModel?

    var state: ImageDto.ImageState
    var data: [CustomizationTagViewData] = .init()

    // MARK: - Initialization

    /// Initializes a new instance of `AppliedStylesViewModel`.
    /// - Parameters:
    ///   - state: The initial state of the image (default is `.none`).
    ///   - toolsColorsViewModel: The view model for managing color tools.
    ///   - toolsPhotosViewModel: The view model for managing photo tools.
    ///   - toolsPicturesViewModel: The view model for managing picture tools.
    ///   - toolsEmojisViewModel: The view model for managing emoji tools.
    init(state: ImageDto.ImageState = .none, toolsColorsViewModel: ToolsColorsViewModel?, toolsPhotosViewModel: ToolsPhotosViewModel?, toolsPicturesViewModel: ToolsPicturesViewModel?, toolsEmojisViewModel: ToolsEmojisViewModel?) {
        self.state = state
        self.toolsColorsViewModel = toolsColorsViewModel
        self.toolsPhotosViewModel = toolsPhotosViewModel
        self.toolsPicturesViewModel = toolsPicturesViewModel
        self.toolsEmojisViewModel = toolsEmojisViewModel
    }

    /// Updates the view model with new state and image customization data.
    /// - Parameters:
    ///   - state: The new state of the image.
    ///   - imageCustomization: The image customization data to update the view model.
    func update(state: ImageDto.ImageState, imageCustomization: ImageCustomisation) {
        self.state = state

        var data: [CustomizationTagViewData] = .init()

        if let color = imageCustomization.selectedColor {
            data.append(.init(text: color.hexString, color: Color(nsColor: color), closeImage: Image(systemName: "xmark.circle"), onClose: { [weak self] in
                self?.toolsColorsViewModel?.selectedColorPublisher.send(nil)
            }))
        }

        if let picture = imageCustomization.selectedPicture {
            data.append(.init(image: picture, text: "", color: Color(.gray50), closeImage: Image(systemName: "xmark.circle"), onClose: { [weak self] in
                self?.toolsPicturesViewModel?.selectedImage = nil
                self?.toolsPhotosViewModel?.selectedAsset = nil
            }))
        }

        if let selectedEmoji = imageCustomization.selectedEmoji {
            data.append(.init(text: String(selectedEmoji), color: Color(.gray50), closeImage: Image(systemName: "xmark.circle"), onClose: { [weak self] in
                self?.toolsEmojisViewModel?.selectedEmoji = nil
            }))
        }

        self.data = data
    }

    // MARK: - Views

    // MARK: - Private

    private func action() {
        // Placeholder for future functionality.
        // NSWorkspace.shared.open(url)
    }
}

/// A view representing a single tag in the customization tag list.
///
/// Redesigned with:
/// - Neutral background for less visual weight
/// - Larger close button (28x28) for better touch target
/// - Minimum height of 40pt
/// - Proper content alignment
///
/// - Parameters:
///   - data: The data used to display the tag, including image, text, color, and actions.
struct StyleTagView: View {
    let data: CustomizationTagViewData

    @State private var isHovered = false
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: .spacingDefault) {
            // Leading content (color swatch, image, or emoji)
            leadingContent

            Spacer()

            // Close button
            if let onClose = data.onClose {
                closeButton(action: onClose)
            }
        }
        .frame(minHeight: 34)
        .padding(.horizontal, .paddingSmall)
        .padding(.vertical, .paddingThin)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: .radiusSmall))
        .onHover { isHovered = $0 }
        .onTapGesture {
            data.onSelect?()
        }
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel(tagAccessibilityLabel)
        .accessibilityHint("Press Delete to remove")
        .accessibilityAddTraits([.isButton])
        // Keyboard support for removal
        .focusable()
        .focused($isFocused)
        .focusEffectDisabled()
        .onKeyPress(.delete) {
            data.onClose?()
            return .handled
        }
        .onKeyPress(KeyEquivalent("\u{7F}")) { // Backspace
            data.onClose?()
            return .handled
        }
    }

    // MARK: - Accessibility

    /// Accessibility label for the style tag
    private var tagAccessibilityLabel: String {
        if data.text.hasPrefix("#") {
            return "Applied color \(data.text)"
        } else if data.image != nil {
            return "Applied image"
        } else if !data.text.isEmpty {
            return "Applied emoji \(data.text)"
        }
        return "Applied style"
    }

    /// Accessibility label for the close button
    private var closeButtonAccessibilityLabel: String {
        if data.text.hasPrefix("#") {
            return "Remove color \(data.text)"
        } else if data.image != nil {
            return "Remove image"
        } else if !data.text.isEmpty {
            return "Remove emoji \(data.text)"
        }
        return "Remove style"
    }

    @ViewBuilder
    private var leadingContent: some View {
        HStack(spacing: .spacingDefault) {
            // Color swatch or image thumbnail
            if let image = data.image {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: .radiusThin))
            } else if !data.text.isEmpty && data.text.hasPrefix("#") {
                // Color swatch for hex colors
                RoundedRectangle(cornerRadius: .radiusThin)
                    .fill(data.color)
                    .frame(width: 28, height: 28)
                    .overlay(
                        RoundedRectangle(cornerRadius: .radiusThin)
                            .strokeBorder(Color.primaryText.opacity(0.2), lineWidth: 1)
                    )
            }

            // Text label
            if !data.text.isEmpty {
                Text(data.text)
                    .font(Typography.headlineMedium)
                    .foregroundStyle(Color.primaryText)
                    .lineLimit(1)
            }
        }
        .padding(.leading, .paddingSmall)
    }

    @ViewBuilder
    private func closeButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color.secondaryText)
                .frame(width: 28, height: 28)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .opacity(isHovered ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .accessibilityLabel(closeButtonAccessibilityLabel)
        .accessibilityHint("Double tap to remove this style")
    }

    @ViewBuilder
    private var backgroundView: some View {
        Color.secondaryBackground
            .opacity(isHovered ? 1.0 : 0.8)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
    }
}

/// Data model representing the view data for a single customization tag.
///
/// - Parameters:
///   - image: An optional image to display in the tag.
///   - text: The text to display in the tag.
///   - color: The color of the text.
///   - closeImage: An optional image for the close button.
///   - onSelect: An optional action to perform when the tag is selected.
///   - onClose: An optional action to perform when the close button is tapped.
struct CustomizationTagViewData: Identifiable {
    typealias ActionClosure = Closure.EmptyBlock

    let id = UUID()
    let image: NSImage?
    let text: String
    let color: Color
    let closeImage: Image?
    let onSelect: ActionClosure?
    let onClose: ActionClosure?

    init(image: NSImage? = nil, text: String = "", color: Color, closeImage: Image? = nil, onSelect: ActionClosure? = nil, onClose: ActionClosure? = nil) {
        self.image = image
        self.text = text
        self.color = color
        self.closeImage = closeImage
        self.onSelect = onSelect
        self.onClose = onClose
    }
}
