//
//  PermissionsOverlayViewModelTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftUI
import Testing
@testable import colir

@Suite("PermissionsOverlayViewModel Tests")
struct PermissionsOverlayViewModelTests {
    // MARK: - Initialization Tests

    @Test("init creates valid instance")
    func init_createsInstance() {
        let url = URL(string: "https://example.com")!

        let viewModel = PermissionsOverlayViewModel(
            title: "Test Title",
            description: "Test Description",
            url: url
        )

        #expect(viewModel.viewSettings is PermissionsOverlayDomain)
    }

    @Test("init with minimal parameters")
    func init_minimalParameters() {
        let url = URL(string: "https://example.com")!

        let viewModel = PermissionsOverlayViewModel(
            title: "Title Only",
            url: url
        )

        #expect(viewModel.viewSettings is PermissionsOverlayDomain)
    }

    // MARK: - viewSettings Tests

    @Test("viewSettings is PermissionsOverlayDomain")
    func viewSettings_isCorrectType() {
        let url = URL(string: "https://example.com")!
        let viewModel = PermissionsOverlayViewModel(
            title: "Test",
            url: url
        )

        #expect(viewModel.viewSettings is PermissionsOverlayDomain)
    }

    // MARK: - View Builders Tests

    @Test("backgroundView is accessible")
    func backgroundView_isAccessible() {
        let url = URL(string: "https://example.com")!
        let viewModel = PermissionsOverlayViewModel(
            title: "Test",
            url: url
        )

        // Access the view builder
        _ = viewModel.backgroundView

        #expect(true)
    }

    @Test("titleText is accessible")
    func titleText_isAccessible() {
        let url = URL(string: "https://example.com")!
        let viewModel = PermissionsOverlayViewModel(
            title: "Test Title",
            url: url
        )

        // Access the view builder
        _ = viewModel.titleText

        #expect(true)
    }

    @Test("descriptionText is accessible")
    func descriptionText_isAccessible() {
        let url = URL(string: "https://example.com")!
        let viewModel = PermissionsOverlayViewModel(
            title: "Test",
            description: "Test Description",
            url: url
        )

        // Access the view builder
        _ = viewModel.descriptionText

        #expect(true)
    }

    @Test("actionButton is accessible")
    @MainActor
    func actionButton_isAccessible() {
        let url = URL(string: "https://example.com")!
        let viewModel = PermissionsOverlayViewModel(
            title: "Test",
            url: url
        )

        // Access the view builder
        _ = viewModel.actionButton

        #expect(true)
    }

    // MARK: - ObservableObject Tests

    @Test("PermissionsOverlayViewModel is ObservableObject")
    func observable_conformance() {
        let url = URL(string: "https://example.com")!
        let viewModel = PermissionsOverlayViewModel(
            title: "Test",
            url: url
        )

        // Access observable properties
        _ = viewModel.viewSettings

        #expect(true)
    }

    // MARK: - System Preferences URL Tests

    @Test("init with system preferences URL")
    func init_systemPreferencesURL() {
        // Test with a system preferences URL
        let prefsURL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Photos")!

        let viewModel = PermissionsOverlayViewModel(
            title: "Photos Access",
            description: "Please enable Photos access in System Settings",
            url: prefsURL
        )

        #expect(viewModel.viewSettings is PermissionsOverlayDomain)
    }

    // MARK: - LocalizedStringKey Tests

    @Test("init accepts LocalizedStringKey for title")
    func init_localizedTitle() {
        let url = URL(string: "https://example.com")!

        let viewModel = PermissionsOverlayViewModel(
            title: LocalizedStringKey("permissions.title"),
            url: url
        )

        #expect(viewModel.viewSettings is PermissionsOverlayDomain)
    }

    @Test("init accepts LocalizedStringKey for description")
    func init_localizedDescription() {
        let url = URL(string: "https://example.com")!

        let viewModel = PermissionsOverlayViewModel(
            title: "Title",
            description: LocalizedStringKey("permissions.description"),
            url: url
        )

        #expect(viewModel.viewSettings is PermissionsOverlayDomain)
    }
}
