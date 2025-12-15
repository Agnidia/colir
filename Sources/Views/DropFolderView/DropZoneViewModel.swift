//
//  DropZoneViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import Combine
import SwiftUI

/// The view model for the `DropZoneView`, managing file drag-and-drop interactions and state updates.
@MainActor
@Observable
final class DropZoneViewModel {
    /// Closure type for handling dropped files.
    typealias FilesClosure = @MainActor ([URL]) -> Void

    /// Closure type for updating the image state.
    typealias UpdateStateClosure = @MainActor (ImageDto.ImageState) -> Void

    /// The current image data and state.
    private(set) var image: ImageDto = .init()

    private(set) var fileClosure: FilesClosure
    private var updateStateClosure: UpdateStateClosure

    private(set) var updatedImagePublisher: PassthroughSubject<ImageDto, Never> = .init()

    /// Collection of cancellable publishers to manage Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()

    /// Animation scale for text when dragging enters the drop zone.
    private(set) var enterZoneAnimationTextScale = 1.0

    /// Animation scale for the image when dragging enters the drop zone.
    private(set) var enterZoneAnimationImageScale = 1.0

    /// Background opacity when dragging enters the drop zone.
    private(set) var enterZoneAnimationBackgroundOpacity: CGFloat = .opacity0

    /// Initializes the view model with the given closures for file handling and state updates.
    /// - Parameters:
    ///   - fileClosure: Closure called with URLs of dropped files.
    ///   - updateStateClosure: Closure called with updated image state.
    init(fileClosure: @escaping FilesClosure, updateStateClosure: @escaping UpdateStateClosure) {
        self.fileClosure = fileClosure
        self.updateStateClosure = updateStateClosure

        addPublishers()
    }

    /// Updates the view model with new image undo items.
    /// - Parameter imageUndoItems: The new image undo items to update the view model with.
    func update(from imageUndoItems: ImageUndoDto) {
        image.update(from: imageUndoItems)
        image.customisations.update(from: imageUndoItems.customisations)
        updatedImagePublisher.send(image)
    }

    /// Adds publishers to observe image state changes.
    private func addPublishers() {
        image.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: update(state:))
            .store(in: &cancellables)
    }

    private func update(state: ImageDto.ImageState) {
        updateStateClosure(state)
        switch state {
        case .preview, .initiated, .ready:
            updatedImagePublisher.send(image)
        case .none, .processing, .error:
            break
        }
    }

    /// Removes all cancellable publishers.
    private func removePublishers() {
        cancellables.removeAll()
    }

    /// Checks if the provided URLs contain any folders.
    /// - Parameter urls: The URLs to check.
    /// - Returns: `true` if any of the URLs are folders; otherwise, `false`.
    func urlsHasFolders(urls: [URL]) -> Bool {
        !urls
            .filter { $0.isFolder && !$0.path().hasSuffix(".app/") }
            .isEmpty
    }

    /// Opens a folder selection dialog for the user to choose directories.
    func openFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.prompt = NSLocalizedString("alert.open.folder", comment: "")
        panel.message = NSLocalizedString("alert.open.folder.message", comment: "")
        let response = panel.runModal()

        guard let urls = response == .OK ? panel.urls : nil else {
            return
        }

        fileClosure(urls)
    }

    /// Animates the text and background when the drag enters or exits the drop zone.
    /// - Parameter hovered: `true` if the drag is within the drop zone; otherwise, `false`.
    func animateText(hovered: Bool) {
        guard hovered else {
            enterZoneAnimationTextScale = 1
            enterZoneAnimationImageScale = 1
            enterZoneAnimationBackgroundOpacity = .zero

            return
        }

        withAnimation {
            enterZoneAnimationTextScale += 0.1
            enterZoneAnimationImageScale += 0.1
            enterZoneAnimationBackgroundOpacity += 0.1

            let animationDuration: Double = .animationDurationFast

            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
                self?.enterZoneAnimationTextScale -= 0.17
                self?.enterZoneAnimationImageScale -= 0.17

                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    if self?.enterZoneAnimationImageScale != 1 {
                        self?.enterZoneAnimationImageScale = 1
                    }
                    if self?.enterZoneAnimationBackgroundOpacity != .zero {
                        self?.enterZoneAnimationBackgroundOpacity = 1
                    }
                }
            }
        }
    }

    /// Handles the delivery of dropped files.
    /// - Parameter urls: The URLs of the dropped files.
    func delivery(urls: [URL]) {
        fileClosure(urls)
    }
}
