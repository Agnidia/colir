//
//  PicturesFolderManager.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

/// A protocol that defines methods for managing images in the "Pictures" folder.
protocol PicturesFolderManagerProtocol {
    
    var picturesDirectory: URL { get }
    
    /// Reads and returns an array of NSImage objects from the "Pictures" folder.
    ///
    /// - Returns: An array of NSImage objects representing images found in the "Pictures" folder.
    /// - Throws: An error if there was a problem reading the images.
    func readImages() async throws -> [PicturesFolderItem]
}

class PicturesFolderManager: PicturesFolderManagerProtocol {
    
    let picturesDirectory: URL
    
    private let supportedTypes: [String] = ["jpg", "jpeg", "png", "gif", "bmp"]
    
    init(picturesDirectory: URL) {
        self.picturesDirectory = picturesDirectory
    }
    
    func readImages() async throws -> [PicturesFolderItem] {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: picturesDirectory, includingPropertiesForKeys: nil, options: [])

        // Filter the file URLs to only include image files (e.g., JPEG or PNG)
        let imageFileURLs = fileURLs.filter { supportedTypes.contains($0.pathExtension.lowercased()) }

        let images = imageFileURLs.compactMap { PicturesFolderItem(name: $0.lastPathComponent, image: NSImage(contentsOf: $0)) }
        
        return images
    }
}
