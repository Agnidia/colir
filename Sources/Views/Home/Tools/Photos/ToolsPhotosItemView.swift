//
//  ToolsPhotosItemView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 10.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Photos

struct ToolsPhotosItemView: View {
    var asset: PhotoAsset
    var cache: PhotoLibraryCacheManager
    var imageSize: CGSize
    
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    
    var body: some View {
        GeometryReader { geo in
            Group {
                if let image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .contentShape( Rectangle()) //fix gesture
                } else {
                    ProgressView()
                        .scaleEffect(0.5)
                }
            }}
        .task {
            guard image == nil else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result {
                        self.image = result.image
                    }
                }
            }
        }
    }
}
