//
//  PrimaryProgressViewStyle.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct PrimaryProgressViewStyle: ProgressViewStyle {
    
    private static let hueColors = stride(from: 0, to: 1, by: 0.1).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }
    
    private var gradient = LinearGradient(
        gradient: Gradient(colors: hueColors),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var labelFontStyle: Font = .caption
    
    var cornerRadius: CGFloat = .radiusSmall
 
    func makeBody(configuration: Configuration) -> some View {
 
        let progress = configuration.fractionCompleted ?? .zero
 
        GeometryReader { geometry in
 
            HStack() {
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemGray))
                    .frame(height: geometry.size.height)
                    .frame(width: geometry.size.width)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(gradient)
                            .frame(width: geometry.size.width * progress)
                            .overlay {
                                if let currentValueLabel = configuration.currentValueLabel {
                                    currentValueLabel
                                        .font(labelFontStyle)
                                        .foregroundColor(.white)
                                }
                            }
                    }
            }
        }
    }
}

extension ProgressViewStyle where Self == PrimaryProgressViewStyle {
    
    /// A button style that doesn't apply a border.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View/buttonStyle(_:)-66fbx`` modifier.
    ///
    /// On tvOS, this button style adds a default hover effect to the first
    /// image of the button's content, if one exists. You can supply a different
    /// hover effect by using the ``View/hoverEffect(_:)`` modifier in the
    /// button's label.
    static var primary: PrimaryProgressViewStyle {
        .init()
    }
}

#Preview("PrimaryProgressViewStyle") {
    VStack {
        ProgressView("dd", value: 0, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("ss", value: 10, total: 100)
            .frame(height: 8)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("", value: 20, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("", value: 30, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("", value: 40, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("", value: 50, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("", value: 60, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("", value: 70, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("", value: 80, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("", value: 90, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
        ProgressView("", value: 1000, total: 100)
            .progressViewStyle(.primary)
        
        Divider()
        
    }
    .frame(width: 200)
    .padding()
}
