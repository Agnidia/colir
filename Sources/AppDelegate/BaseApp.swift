//
//  BaseApp.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import DeveloperSupportStore
import SwiftUI

@main
struct BaseApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var searchText = ""

    @StateObject private var homeViewModel: HomeViewModel
    @StateObject private var toolbarViewModel: ToolbarViewModel

    /// Initializes the app with the shared store service.
    init() {
        let hvm = HomeViewModel(
            undoManager: UndoManager(),
            storeService: StoreService(isLoggingEnabled: false)
        )
        _homeViewModel = StateObject(wrappedValue: hvm)
        _toolbarViewModel = StateObject(wrappedValue: ToolbarViewModel(
            undoManager: hvm.undoManager,
            hasTipped: hvm.hasTipped,
            actionCallback: { action in
                hvm.apply(action: action)
            }
        ))
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(homeViewModel)
                .frame(minWidth: 640, idealWidth: 1024, minHeight: 480, idealHeight: 768)
                .toolbar(id: "mainToolbar") {
                    ToolbarView(viewModel: toolbarViewModel)
                }
                .task {
                    homeViewModel.onTipped = { [weak toolbarViewModel] in
                        toolbarViewModel?.hasTipped = true
                    }
                }
            // .searchable(text: $searchText)
        }
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .commands {
            CommandGroup(after: .newItem) {
                Button(action: homeViewModel.openFolder) {
                    Text("menu.open.folder")
                }
                .keyboardShortcut("o")
            }

            CommandGroup(replacing: .undoRedo) {
                Button("txt.undo") {
                    // Trigger  your own undo with your created undoManager
                    homeViewModel.undoManager.undo()
                }
                .keyboardShortcut(KeyEquivalent("z"), modifiers: [.command])
                .disabled(homeViewModel.undoManager.canUndo == false)
                Button("txt.redo") {
                    // Trigger  your own undo with your created undoManager
                    homeViewModel.undoManager.redo()
                }
                .keyboardShortcut(KeyEquivalent("z"), modifiers: [.command, .shift])
                .disabled(homeViewModel.undoManager.canRedo == false)
            }
        }
    }

    final class AppDelegate: NSObject, NSApplicationDelegate {
        /// base application object
        /// need setup everything inside that object to allow aadd unit tests
        ///
        private(set) lazy var app: Application = .init()

        func applicationDidFinishLaunching(_: Notification) {
            app.setup()
        }

        func applicationDidBecomeActive(_: Notification) {}
    }
}
