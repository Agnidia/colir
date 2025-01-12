//
//  CustomizingActionViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

/// ViewModel for managing the state and actions of the `CustomizingActionView`.
///
/// The `CustomizingActionViewModel` provides a `progressView` and an `actionButton` based on
/// the current state of the view model. It conforms to the `DomainViewConstantProtocol` to
/// manage view settings and provide localized content.
///
/// - Conforms to:
///   - `ObservableObject`: Allows views to observe changes to the view model.
///   - `DomainViewConstantProtocol`: Provides domain-specific settings.
///
/// - Example Usage:
///   ```swift
///   CustomizingActionViewModel(state: .none, actionClosure: {
///       // Handle button action
///   })
///   ```
final class CustomizingActionViewModel: ObservableObject, DomainViewConstantProtocol {
    
    // MARK: - DomainViewConstantProtocol
    
    typealias DomainViewConstantType = CustomizingActionViewDomain
    
    var viewSettings: DomainViewConstantType = .init()
    
    typealias ButtonAction = Commons.EmptyClosure
    
    private let buttonAction: ButtonAction
    
    @Published private var state: ImageDto.ImageState
    
    // MARK: - Variables
    
    /// Initializes a new `CustomizingActionViewModel`.
    /// - Parameters:
    ///   - state: The initial state of the view model. Defaults to `.none`.
    ///   - actionClosure: The action to perform when the button is pressed.
    init(state: ImageDto.ImageState = .none, actionClosure: @escaping ButtonAction) {
        self.state = state
        self.buttonAction = actionClosure
    }
    
    /// Updates the state of the view model.
    /// - Parameter state: The new state to set.
    func update(state: ImageDto.ImageState) {
        self.state = state
    }
    
    // MARK: - Views
    
    /// A view showing a progress indicator if the state is `.processing`.
    ///
    /// Displays a `ProgressView` with the progress value and total of 100 if the state is
    /// `.processing`. Otherwise, it displays an empty view.
    @MainActor
    @ViewBuilder
    var progressView: some View {
        switch state {
        case .processing(let progress):
            ProgressView("", value: progress, total: 100)
                .progressViewStyle(.primary)
        default:
            EmptyView()
        }
    }
    
    /// A button that triggers the `buttonAction` when pressed.
    ///
    /// The button is only enabled if the state is `.ready`. The button's label is set
    /// based on the localization provided by `DomainViewConstantType.Localization.customize`.
    @MainActor
    @ViewBuilder
    var actionButton: some View {
        Button(action: action, label: {
            Text(DomainViewConstantType.Localization.customize)
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primary)
        .disabled(state != .ready)
    }
    
    // MARK: - Private
    
    /// Executes the button action.
    ///
    /// This method is called when the button is pressed, triggering the `buttonAction` closure.
    private func action() {
        buttonAction()
    }
}
