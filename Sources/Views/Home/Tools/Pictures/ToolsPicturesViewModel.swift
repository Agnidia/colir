//
//  ToolsPicturesViewModel.swift
//  colir
//
//  Created by Vitalii P on 07.10.2023.
//

import Foundation

class ToolsPicturesViewModel: ObservableObject {
    private let picturesFolderPath: URL
    
    @Published var images: [PictureItem] = .init()
    
    @Published var selectedImage: PictureItem? = nil
    
    private let picturesFolderManager: PicturesFolderManagerProtocol
    
    private var appSettings: AppSettingsProtocol
    
    private lazy var fileAccessManager: FileAccessManagerProtocol = {
        FileAccessManager(with: appSettings.userPicturesPath, bookmarkData: appSettings.bookmarkData)
    }()
    
    let cellWidth: CGFloat = 192
    let cellHeight: CGFloat = 128
    
    let cellCornerRadius: CGFloat = 8
    
    init(appSettings: AppSettingsProtocol) {
        self.picturesFolderPath = appSettings.userPicturesPath
        self.picturesFolderManager = PicturesFolderManager(picturesDirectory: appSettings.userPicturesPath)
        self.appSettings = appSettings
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
    static var preview: ToolsPicturesViewModel = .init(appSettings: AppSettings.preview)
}
