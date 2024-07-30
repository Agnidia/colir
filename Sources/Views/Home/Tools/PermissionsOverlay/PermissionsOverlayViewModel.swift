//
//  PermissionsOverlayViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 15.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

/// ViewModel for managing the state and presentation of a permissions overlay.
///
/// `PermissionsOverlayViewModel` is responsible for providing the data and actions required
/// for displaying a permissions prompt. It includes methods and properties to configure the overlay's
/// appearance and handle user interactions.
///
/// - Parameters:
///   - title: The title of the overlay, displayed prominently.
///   - description: Additional information or instructions related to the permissions request.
///   - url: The URL to open when the user interacts with the action button (e.g., system preferences).
class PermissionsOverlayViewModel: ObservableObject, DomainViewConstantProtocol {
    
    // MARK: - DomainViewConstantProtocol
    typealias DomainViewConstantType = PermissionsOverlayDomain
    
    var viewSettings: DomainViewConstantType = .init()
    
    // MARK: - Variables
    
    private var title: LocalizedStringKey
    private var description: LocalizedStringKey
    private var url: URL
    
    /// Initializes a new instance of `PermissionsOverlayViewModel`.
    ///
    /// - Parameters:
    ///   - title: The title to be displayed in the overlay.
    ///   - description: Additional descriptive text for the overlay.
    ///   - url: The URL to open when the action button is pressed.
    init(title: LocalizedStringKey, description: LocalizedStringKey = "", url: URL) {
        self.title = title
        self.description = description
        self.url = url
    }
    
    // MARK: - Views
    
    /// The background view for the permissions overlay.
    ///
    /// This view uses a rounded rectangle with the specified background color.
    @ViewBuilder
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: viewSettings.cornerRadius!)
            .fill(viewSettings.background)
    }
    
    /// The title text displayed in the overlay.
    ///
    /// This uses a title font style for prominence.
    @ViewBuilder
    var titleText: some View {
        Text(title)
            .font(.title)
    }
    
    /// The description text displayed in the overlay.
    ///
    /// This uses a body font style for additional information.
    @ViewBuilder
    var descriptionText: some View {
        Text(description)
            .font(.body)
    }
    
    /// The action button for the overlay.
    ///
    /// This button triggers an action to open the specified URL, such as system preferences.
    @ViewBuilder
    var actionButton: some View {
        Button(action: action, label: {
            Text(DomainViewConstantType.Localization.openSettings)
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
        })
        .tint(ButtonStyleConstants.backgroundAccentColor)
        .buttonStyle(.accent)
    }
    
    // MARK: - Private
    
    /// Opens the specified URL.
    ///
    /// This method is called when the action button is pressed.
    private func action() {
        NSWorkspace.shared.open(url)
    }
}
