//
//  ToolsPicturesViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Throttler

/// A view model responsible for managing and providing picture data to the `ToolsPicturesView`.
///
/// `ToolsPicturesViewModel` handles fetching images from a specified directory, managing selected images,
/// and providing view-related properties for presenting images in a grid format.
///
/// - Properties:
///   - `images`: The array of `PictureItem` objects representing images to be displayed.
///   - `selectedImage`: The currently selected `PictureItem`, or `nil` if no image is selected.
///   - `columns`: A grid layout configuration for displaying images in a responsive grid.
///   - `cell(for:)`: Generates a view for a given `PictureItem`, including selection indication.
///
/// - Methods:
///   - `fetchImages()`: Initiates the process of fetching images from the specified directory.
///   - `setupAccess()`: Checks and sets up access to the image directory if needed.
///
/// - Initialization:
///   - `init(appSettings:picturesFolderManager:)`: Initializes with app settings and a folder manager for managing pictures.
class ToolsPicturesViewModel: ObservableObject {
    private let picturesFolderPath: URL
    
    @Published var images: [PictureItem] = .init()
    
    //TODO: set it private(set)
    @Published var selectedImage: PictureItem? = nil
    
    private let picturesFolderManager: PicturesFolderManagerProtocol
    private var appSettings: AppSettingsProtocol
    private var isFetching: Bool = false
    
    private lazy var fileAccessManager: FileAccessManagerProtocol = {
        FileAccessManager(with: appSettings.userPicturesPath, bookmarkData: appSettings.bookmarkData)
    }()
    
    private let cellWidth: CGFloat = 192
    private let cellHeight: CGFloat = 128
    private let cellCornerRadius: CGFloat = .radiusSmall
    
    /// Initializes the view model with app settings and a folder manager.
    ///
    /// - Parameters:
    ///   - appSettings: An object conforming to `AppSettingsProtocol` that provides app settings.
    ///   - picturesFolderManager: An object conforming to `PicturesFolderManagerProtocol` for managing picture folders.
    init(appSettings: AppSettingsProtocol, picturesFolderManager: PicturesFolderManagerProtocol) {
        self.picturesFolderPath = appSettings.userPicturesPath
        self.picturesFolderManager = picturesFolderManager
        self.appSettings = appSettings
    }
    
    /// Provides a grid layout configuration for displaying images in a responsive grid.
    ///
    /// - Returns: An array of `GridItem` defining the grid layout.
    var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: cellWidth))
        ]
    }
    
    /// Generates a view for a given `PictureItem`, including a selection indication overlay.
    ///
    /// - Parameter item: The `PictureItem` to be displayed in the grid.
    /// - Returns: A `View` representing the image cell, with selection indication if applicable.
    @ViewBuilder
    func cell(for item: PictureItem) -> some View {
        Image(nsImage: item.image)
            .resizable()
            .frame(width: cellWidth, height: cellHeight)
            .cornerRadius(cellCornerRadius)
            .overlay(
                ZStack(alignment: .bottomTrailing) {
                    let isSelected = selectedImage == item
                    RoundedRectangle(cornerRadius: cellCornerRadius)
                        .strokeBorder(isSelected ? Color.blue : Color.gray, lineWidth: isSelected ? 4 : 1)
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.title)
                            .padding(.paddingSmall)
                    }
                }
            )
            .onTapGesture { [weak self] in
                if self?.selectedImage == item {
                    self?.selectedImage = nil
                } else {
                    self?.selectedImage = item
                }
            }
    }
    
    /// Initiates the process of fetching images from the specified directory.
    ///
    /// Uses throttling to debounce rapid calls and fetch images asynchronously.
    func fetchImages() {
        debounce(.milliseconds(100)) { [weak self] in
            Task { [weak self] in
                await self?._fetchImages()
            }
        }
    }
    
    private func _fetchImages() async {
        if appSettings.userPicturesPath.hasAccess {
            guard isFetching == false else { return }
            
            isFetching = true
            
            do {
                let images = try await picturesFolderManager.readImages()
                let pictures = images.map { PictureItem(name: $0.name, tags: [$0.name], image: $0.image) }
                
                if self.images != pictures {
                    Task { @MainActor [weak self] in
                        self?.images.removeAll()
                        debounce(.milliseconds(100)) { [weak self] in
                            self?.images.append(contentsOf: pictures)
                            self?.isFetching = false
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            Task { @MainActor [weak self] in
                self?.setupAccess()
            }
        }
    }
    
    /// Checks and sets up access to the image directory if needed.
    ///
    /// Updates the app's access data and re-fetches images if access is granted.
    fileprivate func setupAccess() {
        do {
            let accessData = try fileAccessManager.checkAndSetupDataAccessIfNeeded()
            // Update access to Xcode data folder
            appSettings.bookmarkData = accessData.bookmark
            appSettings.userPicturesPath = accessData.path
            
            fetchImages()
        } catch {
            // Mark app's access to Xcode data folder as invalid
            appSettings.bookmarkData = Data()
        }
    }
}

extension ToolsPicturesViewModel {
    static var preview: ToolsPicturesViewModel = .init(
        appSettings: AppSettings.preview,
        picturesFolderManager: PicturesFolderManager(picturesDirectory: URL(string: "")!)
    )
}
