//
//  ToolsPhotosItemView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 10.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Photos

/// A SwiftUI view that displays a photo asset from the user's photo library.
///
/// `ToolsPhotosItemView` is used to present an individual photo asset, fetching and displaying the image using a cache manager. It shows a progress indicator while the image is being loaded and handles image requests asynchronously.
///
/// - Properties:
///   - `asset`: The photo asset to be displayed.
///   - `cache`: The cache manager responsible for fetching the image from the photo library.
///   - `imageSize`: The target size of the image to be fetched.
///   - `image`: A state property holding the loaded image.
///   - `imageRequestID`: A state property holding the image request ID for managing the asynchronous image fetch.
///
/// - Views:
///   - `GeometryReader`: Provides access to the size of the container view.
///   - `Group`: Used to conditionally display the image or a progress view.
///   - `Image`: Displays the fetched image, resized and scaled to fill the container.
///   - `ProgressView`: Shows a loading indicator while the image is being fetched.
///
/// - Tasks:
///   - `task`: Asynchronously fetches the image from the cache if it has not already been loaded.
///
/// - Preview:
///   - A preview instance of `ToolsPhotosItemView` is provided to visualize the view's layout and behavior in Xcode's canvas.

struct ToolsPhotosItemView: View {
    var asset: PhotoAsset
    var cache: PhotoLibraryCacheManager
    var imageSize: CGSize
    
    @State private(set) var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    
    var body: some View {
        GeometryReader { geo in
            Group {
                if let image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .contentShape(Rectangle()) // Fix gesture issues
                } else {
                    ProgressView()
                        .scaleEffect(0.5)
                }
            }
        }
        .task {
            guard image == nil else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize, completion: process(result:))
        }
    }
    
    private func process(result: PhotoLibraryCacheManager.ImageResult) {
        Task { [result] in
            if let image = result?.image {
                self.image = Image(nsImage: image)
            }
        }
    }
}
