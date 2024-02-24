//
//  ToolsPicturesViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Throttler

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
    
    init(appSettings: AppSettingsProtocol, picturesFolderManager: PicturesFolderManagerProtocol) {
        self.picturesFolderPath = appSettings.userPicturesPath
        self.picturesFolderManager = picturesFolderManager
        self.appSettings = appSettings
    }
    
    var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: cellWidth))
        ]
    }
    
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
    
    @Sendable
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
    
    @Sendable
    fileprivate func setupAccess() {
        do {
            let accessData = try fileAccessManager.checkAndSetupDataAccessIfNeeded()
            // update access to Xcode data folder
            appSettings.bookmarkData = accessData.bookmark
            appSettings.userPicturesPath = accessData.path
            
            fetchImages()
            
            //log.info("setup success")
        } catch {
            // mark app's assess to Xcode data folder as invalid
            appSettings.bookmarkData = Data()
            //log.info("setup failed: \(error.localizedDescription)")
        }
    }
}

extension ToolsPicturesViewModel {
    static var preview: ToolsPicturesViewModel = .init(appSettings: AppSettings.preview, picturesFolderManager: PicturesFolderManager(picturesDirectory: URL(string: "")!))
}
