//
//  AboutView.swift
//
//  Created on 20.10.2026.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import AppKit
import CustomizedAboutView
import SwiftUI

struct AboutView: View {
    private static let otherAppIDs = [1_583_462_846, 6_759_503_967, 1_661_688_468]

    fileprivate static var appName: String {
        CustomizedAboutMetadata().name
    }

    private var configuration: CustomizedAboutConfiguration {
        let bundleMetadata = CustomizedAboutMetadata()
        let year = Calendar.current.component(.year, from: Date())
        let metadata = CustomizedAboutMetadata(
            name: bundleMetadata.name,
            version: bundleMetadata.version,
            build: bundleMetadata.build,
            bundleIdentifier: bundleMetadata.bundleIdentifier,
            copyright: "© 2008 - \(year) Agnidia"
        )

        return CustomizedAboutConfiguration(
            metadata: metadata,
            appStoreIDs: Self.otherAppIDs,
            developerWebsite: URL(string: "https://agnidia.com/"),
            supportWebsite: URL(string: "https://agnidia.com/support"),
            contactWebsite: URL(string: "mailto:support@agnidia.com")
        )
    }

    var body: some View {
        CustomizedAboutView(configuration: configuration) {
            Image(nsImage: NSImage.appIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
        }
    }
}

extension NSImage {
    /// The main bundle app icon in the current system style.
    static var appIcon: NSImage {
        NSWorkspace.shared.icon(forFile: Bundle.main.bundlePath)
    }
}

extension AboutView {
    static var window: some Scene {
        Window("About \(appName)", id: "about") {
            AboutView()
                .toolbar(removing: .title)
                .toolbarBackground(.hidden, for: .windowToolbar)
                .containerBackground(.regularMaterial, for: .window)
                .windowMinimizeBehavior(.disabled)
        }
        .windowBackgroundDragBehavior(.enabled)
        .windowResizability(.contentSize)
        .restorationBehavior(.disabled)
    }
}
