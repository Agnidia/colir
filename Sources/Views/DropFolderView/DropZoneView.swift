//
//  DropZoneView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct DropZoneView: View {
    
    @EnvironmentObject var viewModel: DropZoneViewModel
    
    var body: some View {
#if DEBUG
        // Prints changes for debug purposes.
        let _ = Self._printChanges()
#endif
        
        DropZoneNSView.SwiftUI(isEnabled: true,
                             allowsMultipleDrop: false,
                             validateFiles: { urls in
            return (viewModel.urlsHasFolders(urls: urls) == true) ? .copy : NSDragOperation()
        },
                             enterZone: { entered in
            viewModel.isWaitingDropping = entered
            viewModel.animateText(hovered: entered)
        },
                             dropFiles: { urls in
            viewModel.delivery(urls: urls)
            
            return true
        })
        .background(content: {
            viewModel.backgroundView
        })
        .overlay(content: {
            viewModel.overlayView
        })
        .onTapGesture {
            viewModel.openFolder()
        }
        .onHover(perform: { hovered in
            viewModel.animateText(hovered: hovered)
        })
    }
}

#Preview("ToolsColorsView") {
    DropZoneView()
        .environmentObject(DropZoneViewModel(fileClosure: {_ in}, updateStateClosure: {_ in}))
        .frame(width: 300, height: 300)
        .padding(.paddingDefault)
}
