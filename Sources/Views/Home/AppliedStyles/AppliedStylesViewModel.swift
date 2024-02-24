//
//  AppliedStylesViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons
import SwiftUICustomTagListView

class AppliedStylesViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    typealias DomainViewConstantType = AppliedStylesViewDomain
    
    var viewSettings: DomainViewConstantType = .init()
    
    private var toolsColorsViewModel: ToolsColorsViewModel?
    private var toolsPhotosViewModel: ToolsPhotosViewModel?
    private var toolsPicturesViewModel: ToolsPicturesViewModel?
    private var toolsEmojisViewModel: ToolsEmojisViewModel?
        
    @Published var state: ImageDto.ImageState
    
    @Published var data: [CustomizationTagViewData] = .init()
    
    var views: [SwiftUICustomTagView<SampleTagView>] {
        self.data.map { data in
            SwiftUICustomTagView(content: {
                SampleTagView(data: data)
            })
        }
    }
    
    //MARK: - Variables
    
    init(state: ImageDto.ImageState = .none, toolsColorsViewModel: ToolsColorsViewModel?, toolsPhotosViewModel: ToolsPhotosViewModel?, toolsPicturesViewModel: ToolsPicturesViewModel?, toolsEmojisViewModel: ToolsEmojisViewModel?) {
        self.state = state
        self.toolsColorsViewModel = toolsColorsViewModel
        self.toolsPhotosViewModel = toolsPhotosViewModel
        self.toolsPicturesViewModel = toolsPicturesViewModel
        self.toolsEmojisViewModel = toolsEmojisViewModel
    }
    
    func update(state: ImageDto.ImageState, imageCustomization: ImageCustomization) {
        self.state = state
        
        var data: [CustomizationTagViewData] = .init()
        
        if let color = imageCustomization.selectedColor {
            data.append(.init(text: color.hexString, color: Color(nsColor: color), closeImage: Image(systemName: "xmark.circle"), onClose: { [weak self] in
                self?.toolsColorsViewModel?.selectedColor = nil
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
    
    //MARK: - Views
    
    @ViewBuilder
    var tagsView: some View {
        SwiftUICustomTagListView(views, horizontalSpace: .spacingDefault, verticalSpace: .spacingDefault)
    }
    
    //MARK: - Private
    
    private func action() {
        //NSWorkspace.shared.open(url)
    }
}


// MARK: - Define your own component

struct SampleTagView: View {
    
    let data: CustomizationTagViewData
    
    var body: some View {
        HStack(spacing: .spacingDefault) {
            if let image = data.image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 20)
                    .shadow(color: .black, radius: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if data.text.isEmpty == false {
                Text(data.text)
                    .foregroundStyle(data.color)
                    .shadow(color: .black, radius: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let closeImage = data.closeImage, let onClose = data.onClose {
                Button(action: onClose) {
                    closeImage
                        .shadow(color: .black, radius: 1)
                }
                .buttonStyle(.borderless)
            }
        }
        .onTapGesture {
            if let onSelect = data.onSelect {
                onSelect()
            }
        }
        .font(.title2)
        .foregroundColor(.white)
        .padding(.horizontal, .paddingSmall)
        .padding(.vertical, .paddingThin)
        .background(.accent)
        .cornerRadius(.radiusThin)
    }
}

struct CustomizationTagViewData {
    
    typealias ActionClosure = Closure.EmptyBlock
    
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
