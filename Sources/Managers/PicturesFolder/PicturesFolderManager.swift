//
//  PicturesFolderManager.swift
//
//  Created on 07.10.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit

/// A protocol that defines methods for managing images in the "Pictures" folder.
protocol PicturesFolderManagerProtocol {
    /// The URL of the "Pictures" directory.
    var picturesDirectory: URL { get }

    /// Reads and returns an array of `PicturesFolderItem` objects from the "Pictures" folder.
    ///
    /// - Returns: An array of `PicturesFolderItem` objects representing images found in the "Pictures" folder.
    /// - Throws: An error if there was a problem reading the images.
    func readImages() async throws -> [PicturesFolderItem]
}

/// A class that manages and retrieves images from the "Pictures" folder.
final class PicturesFolderManager: PicturesFolderManagerProtocol {
    /// The URL of the "Pictures" directory.
    let picturesDirectory: URL

    /// Supported image file extensions.
    private let supportedTypes: [String] = ["jpg", "jpeg", "png", "gif", "bmp"]

    /// Initializes a new `PicturesFolderManager` with the specified directory.
    ///
    /// - Parameter picturesDirectory: The URL of the "Pictures" directory.
    init(picturesDirectory: URL) {
        self.picturesDirectory = picturesDirectory
    }

    /// Reads and returns an array of `PicturesFolderItem` objects from the "Pictures" folder.
    ///
    /// - Returns: An array of `PicturesFolderItem` objects representing images found in the "Pictures" folder.
    /// - Throws: An error if there was a problem reading the images.
    func readImages() async throws -> [PicturesFolderItem] {
        // Retrieve file URLs from the pictures directory.
        let fileURLs = try FileManager.default.contentsOfDirectory(at: picturesDirectory, includingPropertiesForKeys: nil, options: [])

        // Filter the file URLs to only include supported image files (e.g., JPEG, PNG).
        let imageFileURLs = fileURLs.filter { supportedTypes.contains($0.pathExtension.lowercased()) }

        // Map file URLs to `PicturesFolderItem` objects, loading images as `NSImage`.
        let images = imageFileURLs.compactMap { PicturesFolderItem(name: $0.lastPathComponent, image: NSImage(contentsOf: $0)) }

        return images
    }
}
