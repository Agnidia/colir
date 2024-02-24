//
//  ColorWheelView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import SwiftUI

struct ColorWheelView: NSViewRepresentable {
    
    internal class Coordinator: NSObject, ColorWheelViewDelegate {
        var colorWheel: ColorWheelNSView?
        
        func didChangeColor(hue: Double, saturation: Double, brightness: Double) {
            colorWheel?.updateContents(hue: hue, saturation: saturation, brightness: brightness)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> ColorWheelNSView {
        let colorWheel = ColorWheelNSView()
        colorWheel.frame = .init(origin: .zero, size: .init(width: 200, height: 200))
        colorWheel.layout()
        
        colorWheel.delegate = context.coordinator
        context.coordinator.colorWheel = colorWheel
        
        colorWheel.updateContents(hue: .zero, saturation: .zero, brightness: 1)
        
        return colorWheel
    }

    func updateNSView(_ nsView: ColorWheelNSView, context: Context) {
    }
}
