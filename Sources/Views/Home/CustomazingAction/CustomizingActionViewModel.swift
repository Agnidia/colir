//
//  CustomizingActionViewModel.swift
//
//  Created on 30.10.2023.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftCommons
import SwiftUI

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
@Observable
final class CustomizingActionViewModel: DomainViewConstantProtocol {
    // MARK: - DomainViewConstantProtocol

    typealias DomainViewConstantType = CustomizingActionViewDomain

    var viewSettings: DomainViewConstantType = .init()

    typealias ButtonAction = Commons.MainActorEmptyClosure

    private let buttonAction: ButtonAction

    private(set) var state: ImageDto.ImageState

    // MARK: - Variables

    /// Initializes a new `CustomizingActionViewModel`.
    /// - Parameters:
    ///   - state: The initial state of the view model. Defaults to `.none`.
    ///   - actionClosure: The action to perform when the button is pressed.
    init(state: ImageDto.ImageState = .none, actionClosure: @escaping ButtonAction) {
        self.state = state
        buttonAction = actionClosure
    }

    /// Updates the state of the view model.
    /// - Parameter state: The new state to set.
    func update(state: ImageDto.ImageState) {
        self.state = state
    }

    // MARK: - Actions

    /// Executes the button action.
    ///
    /// This method is called when the button is pressed, triggering the `buttonAction` closure.
    @MainActor
    func action() {
        buttonAction()
    }
}
