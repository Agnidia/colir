//
//  ToolsPhotosItemView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 10.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Photos
import SwiftUI

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

    /// Loading states for the photo item
    enum LoadingState {
        case loading
        case loaded(Image)
        case error
    }

    @State private var loadingState: LoadingState = .loading
    @State private var imageRequestID: PHImageRequestID?

    var body: some View {
        GeometryReader { geo in
            contentView(size: geo.size)
        }
        .task {
            await loadImage()
        }
    }

    @ViewBuilder
    private func contentView(size: CGSize) -> some View {
        switch loadingState {
        case .loading:
            loadingView(size: size)

        case let .loaded(image):
            image
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .contentShape(Rectangle())
                .transition(.opacity.combined(with: .scale(scale: 0.95)))

        case .error:
            errorView(size: size)
        }
    }

    /// Skeleton loading view with shimmer animation
    @ViewBuilder
    private func loadingView(size: CGSize) -> some View {
        ZStack {
            ImageSkeletonView(cornerRadius: .radiusSmall)
                .frame(width: size.width, height: size.height)

            ProgressView()
                .scaleEffect(0.8)
                .tint(Color.secondaryText)
        }
    }

    /// Error state view with retry option
    @ViewBuilder
    private func errorView(size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: .radiusSmall)
                .fill(Color.secondaryBackground)
                .frame(width: size.width, height: size.height)

            VStack(spacing: .spacingSmall) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.secondaryText)

                Text("Tap to retry")
                    .font(Typography.labelSmall)
                    .foregroundStyle(Color.secondaryText)
            }
        }
        .onTapGesture {
            Task {
                await loadImage()
            }
        }
    }

    /// Loads the image from cache
    private func loadImage() async {
        loadingState = .loading

        imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
            Task { @MainActor in
                if let nsImage = result?.image {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        loadingState = .loaded(Image(nsImage: nsImage))
                    }
                } else {
                    loadingState = .error
                }
            }
        }
    }
}
