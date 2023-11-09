//
//  ToolsPicturesViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//

import SwiftUI

class ToolsPicturesViewModel: ObservableObject {
    private let picturesFolderPath: URL
    
    @Published var images: [PictureItem] = .init()
    
    //TODO: set it private(set)
    @Published var selectedImage: PictureItem? = nil
    
    private let picturesFolderManager: PicturesFolderManagerProtocol
    
    private var appSettings: AppSettingsProtocol
    
    private lazy var fileAccessManager: FileAccessManagerProtocol = {
        FileAccessManager(with: appSettings.userPicturesPath, bookmarkData: appSettings.bookmarkData)
    }()
    
    private let cellWidth: CGFloat = 192
    private let cellHeight: CGFloat = 128
    
    private let cellCornerRadius: CGFloat = 8
    
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
                            .padding(8)
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
    func fetchImages() async {
        if appSettings.userPicturesPath.hasAccess {
            do {
                let images = try await picturesFolderManager.readImages()
                
                DispatchQueue.main.async { [weak self] in
                    self?.images = images.map({ PictureItem(name: $0.name, tags: [], image: $0.image) })
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
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
            
            Task {
                await fetchImages()
            }
            
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
