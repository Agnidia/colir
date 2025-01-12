//
//  CustomizingActionView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view that displays actions and progress related to customization.
///
/// The `CustomizingActionView` shows a progress view and an action button based on the state of
/// `CustomizingActionViewModel`. The layout consists of a vertical stack with the progress view
/// on top and the action button below.
///
/// - EnvironmentObject:
///   - `viewModel`: The view model providing the state and actions for the view.
///
/// - Example Usage:
///   ```swift
///   CustomizingActionView()
///       .environmentObject(CustomizingActionViewModel(state: .none, actionClosure: {}))
///   ```
struct CustomizingActionView: View {
    @EnvironmentObject var viewModel: CustomizingActionViewModel
    
    var body: some View {
        viewModel.actionButton
            .overlay {
                viewModel.progressView
            }
            .padding([.horizontal, .bottom], .paddingDefault)
    }
}

// MARK: - Previews

/// Preview for `CustomizingActionView` showing different states.
///
/// This preview displays `CustomizingActionView` in various states:
/// - `.none`
/// - `.ready`
/// - `.preview`
/// - `.processing(value: 30)`
/// - `.error`
///
/// - Returns: A `VStack` containing multiple instances of `CustomizingActionView`
///   with different states for testing and design purposes.
#Preview("CustomizingActionView") {
    VStack {
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .none, actionClosure: {}))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .ready, actionClosure: {}))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .preview, actionClosure: {}))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .processing(value: 30), actionClosure: {}))
        
        Divider()
        
        CustomizingActionView()
            .environmentObject(CustomizingActionViewModel(state: .error, actionClosure: {}))
        
        Divider()
        Spacer()
    }
    .frame(width: 236, height: 450)
}
