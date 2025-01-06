//
//  VisualEffectView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI

extension EnvironmentValues {
    /// The material type for the visual effect view.
    @Entry var visualEffectMaterial: NSVisualEffectView.Material? = nil
    
    /// The blending mode for the visual effect view.
    @Entry var visualEffectBlending: NSVisualEffectView.BlendingMode? = nil
    
    /// Indicates if the visual effect view is emphasized.
    @Entry var visualEffectEmphasized: Bool? = nil
}

/// A SwiftUI view that wraps an `NSVisualEffectView` to apply visual effects.
struct VisualEffectView<Content: View>: NSViewRepresentable {
    private let material: NSVisualEffectView.Material
    private let blendingMode: NSVisualEffectView.BlendingMode
    private let isEmphasized: Bool
    private let content: Content
    
    /// Initializes a `VisualEffectView` with the specified visual effect properties and content.
    ///
    /// - Parameters:
    ///   - content: The content view to be displayed within the visual effect view.
    ///   - material: The material type of the visual effect view.
    ///   - blendingMode: The blending mode of the visual effect view. Defaults to `.behindWindow`.
    ///   - emphasized: A Boolean value indicating whether the visual effect view is emphasized. Defaults to `false`.
    fileprivate init(
        content: Content,
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode,
        emphasized: Bool) {
        self.content = content
        self.material = material
        self.blendingMode = blendingMode
        self.isEmphasized = emphasized
    }
    
    /// Creates and configures the `NSVisualEffectView` for use in the SwiftUI view hierarchy.
    ///
    /// - Parameter context: The context containing the state and environment values.
    /// - Returns: A configured `NSVisualEffectView` instance.
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        let wrapper = NSHostingView(rootView: content)
        view.state = .active
        // Not certain how necessary this is
        view.autoresizingMask = [.width, .height]
        view.alphaValue = 0.25
        wrapper.autoresizingMask = [.width, .height]
        wrapper.frame = view.bounds
        
        view.addSubview(wrapper)
        return view
    }
    
    /// Updates the `NSVisualEffectView` with new properties from the environment.
    ///
    /// - Parameters:
    ///   - nsView: The `NSVisualEffectView` to be updated.
    ///   - context: The context containing the state and environment values.
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = context.environment.visualEffectMaterial ?? material
        nsView.blendingMode = context.environment.visualEffectBlending ?? blendingMode
        nsView.isEmphasized = context.environment.visualEffectEmphasized ?? isEmphasized
    }
}

extension View {
    /// Applies a visual effect to a view using `NSVisualEffectView`.
    ///
    /// - Parameters:
    ///   - material: The material type of the visual effect view.
    ///   - blendingMode: The blending mode of the visual effect view. Defaults to `.behindWindow`.
    ///   - emphasized: A Boolean value indicating whether the visual effect view is emphasized. Defaults to `false`.
    /// - Returns: A view with the specified visual effect applied.
    func visualEffect(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        emphasized: Bool = false
    ) -> some View {
        VisualEffectView(
            content: self,
            material: material,
            blendingMode: blendingMode,
            emphasized: emphasized
        )
    }
}
