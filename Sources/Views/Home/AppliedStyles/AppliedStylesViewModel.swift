//
//  AppliedStylesViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

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
/// - Parameters:
///   - data: The data used to display the tag, including image, text, color, and actions.
struct StyleTagView: View {
    
    let data: CustomizationTagViewData
    
    var body: some View {
        HStack(spacing: .spacingDefault) {
            if let closeImage = data.closeImage, let onClose = data.onClose {
                Button(action: onClose) {
                    closeImage
                        .resizable()
                        .frame(width: .FrameSize.Button.small, height: .FrameSize.Button.small)
                        .shadow(color: .black, radius: 1)
                        .padding([.trailing], .paddingThin)
                        .overlay { Color.white0 }
                }
                .buttonStyle(.borderless)
            }
            
            Group {
                if let image = data.image {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                }
                
                if !data.text.isEmpty {
                    Text(data.text)
                        .font(.title3)
                        .padding(.vertical, .paddingThin + .paddingUltraThin)
                        .foregroundStyle(data.color)
                }
            }
            .shadow(color: .white, radius: 1)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onTapGesture {
            if let onSelect = data.onSelect {
                onSelect()
            }
        }
        .font(.title2)
        .foregroundColor(.white)
        .padding(.horizontal, .paddingSmall)
        .padding(.vertical, .paddingUltraThin)
        .background(.accentBackgroundButton.opacity(0.8))
        .cornerRadius(.radiusThin)
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
