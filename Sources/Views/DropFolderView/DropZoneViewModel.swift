//
//  DropZoneViewModel.swift
//  colir
//
//  Created by Vitalii P on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI
import Combine

final class DropZoneViewModel: ObservableObject {
    
    typealias FilesClosure = ([URL]) -> ()
    
    typealias UpdateStateClosure = (ImageDto.ImageState) -> ()
    
    @Published private(set) var image: ImageDto = .init()
    @Published var customizations: ImageCustomizationDto = .init()
    @Published private var imageUpdateHack = false
    
    private var fileClosure: FilesClosure
    
    private var updateStateClosure: UpdateStateClosure
    
    /// Collection of cancellable publishers to clean up when done.
    private var cancellables = Set<AnyCancellable>()
    
    var isWaitingDropping: Bool = false
    @Published var isEnterZone: Bool = false
    @Published var isEnterZoneAnimation: Bool = false
    @Published private var enterZoneAnimationTextScale = 1.0
    @Published private var enterZoneAnimationImageScale = 1.0
    @Published private var enterZoneAnimationBackgroundOpacity = 0.0
    
    init(fileClosure: @escaping FilesClosure, updateStateClosure: @escaping UpdateStateClosure) {
        self.fileClosure = fileClosure
        self.updateStateClosure = updateStateClosure
        
        addPublishers()
    }
    
    private func addPublishers() {
        image.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateStateClosure(state)
                self?.imageUpdateHack.toggle()
            }
            .store(in: &cancellables)
    }
    
    private func removePublishers() {
        cancellables.removeAll()
    }
    
    func urlsHasFolders(urls: [URL]) -> Bool {
        !urls
            .filter {
                $0.isFolder && !$0.path().hasSuffix(".app/")
            }
            .isEmpty
    }
    
    @ViewBuilder
    var backgroundView: some View {
        ZStack {
            Rectangle()
                .fill(.dropFolderViewBackgroundActive)
                .opacity(enterZoneAnimationBackgroundOpacity)
                .cornerRadius(8)
            
            if image.state == .none {
                
                if #available(macOS 14, *) {
                    Image(systemName: "folder.badge.plus")
                        .resizable()
                        .symbolEffect(.bounce, value: isEnterZoneAnimation)
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(.secondaryText, .green)
                        .aspectRatio(contentMode: .fit)
                        .fontWeight(.thin)
                        .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 4))
                } else {
                    Image(systemName: "folder.badge.plus")
                        .resizable()
                        .symbolRenderingMode(.multicolor)
                        .scaleEffect(enterZoneAnimationImageScale)
                        .animation(.spring(duration: ViewConstants.animation, bounce: 0.5), value: enterZoneAnimationImageScale)
                        .fontWeight(.thin)
                        .aspectRatio(contentMode: .fit)
                        .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 4))
                }
            } else {
                image.preview
                    .scaleEffect(enterZoneAnimationImageScale)
                    .animation(.spring(duration: ViewConstants.animation, bounce: 0.5), value: enterZoneAnimationImageScale)
                    .padding(8)
            }
        }
    }
    
    private var overlayText: LocalizedStringKey {
        var text = HomeViewDomain.Localization.dragHere
        if isEnterZone {
            text = HomeViewDomain.Localization.choice
        }
        if isWaitingDropping {
            text = HomeViewDomain.Localization.dropHere
        }
        
        return text
    }
    @ViewBuilder
    var overlayView: some View {
        if image.state == .none {
            Text(overlayText)
                .font(.title)
                .scaleEffect(enterZoneAnimationTextScale)
                .animation(.spring(duration: ViewConstants.animation, bounce: 0.5), value: enterZoneAnimationTextScale)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondaryText)
                .padding(40)
                .offset(x: -20, y: 24)
        }
    }
    
    func openFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.prompt = NSLocalizedString("Choose", comment: "")
        panel.message = NSLocalizedString("Choose folder to colorise it", comment: "")
        let response = panel.runModal()
        
        guard let urls = response == .OK ? panel.urls : nil else {
            return
        }
        
        fileClosure(urls)
    }
    
    func animateText(hovered: Bool) {
        guard hovered else {
            isEnterZone = false
            
            enterZoneAnimationTextScale = 1
            enterZoneAnimationImageScale = 1
            enterZoneAnimationBackgroundOpacity = 0
            
            return
        }
        
        withAnimation {
            isEnterZone = true
            
            isEnterZoneAnimation.toggle()
            
            enterZoneAnimationTextScale += 0.1
            enterZoneAnimationImageScale += 0.1
            enterZoneAnimationBackgroundOpacity += 0.1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + ViewConstants.animation) { [weak self] in
                self?.enterZoneAnimationTextScale = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + ViewConstants.animation / 2) {
                    if self?.enterZoneAnimationImageScale != 1 {
                        self?.enterZoneAnimationImageScale = 1
                    }
                    if self?.enterZoneAnimationBackgroundOpacity != 0 {
                        self?.enterZoneAnimationBackgroundOpacity = 1
                    }
                }
            }
        }
    }
    
    func delivery(urls: [URL]) {
        fileClosure(urls)
    }
}
