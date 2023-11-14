//
//  BaseApp.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//

import SwiftUI

@main
struct BaseApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var searchText = ""
    
    @StateObject private var homeViewModel: HomeViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(homeViewModel)
                .frame(minWidth: 640, idealWidth: 1024, minHeight: 480, idealHeight: 768)
                .toolbar(id: "mainToolbar") {
                    ToolbarView(viewModel: ToolbarViewModel(undoManager: homeViewModel.undoManager , actionCallback: { action in
                        homeViewModel.apply(action: action)
                    }))
                }
                .searchable(text: $searchText)
        }
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            CommandGroup(after: .newItem) {
                Button(action: homeViewModel.openFolder) {
                    Text("Open Folder...")
                }
                .keyboardShortcut("o")
            }
            
            CommandGroup(replacing: .undoRedo) {
                Button("Undo") {
                    //Trigger  your own undo with your created undoManager
                    homeViewModel.undoManager.undo()
                }
                .keyboardShortcut(KeyEquivalent("z"), modifiers: [.command])
                .disabled(homeViewModel.undoManager.canUndo == false)
                Button("Redo") {
                    //Trigger  your own undo with your created undoManager
                    homeViewModel.undoManager.redo()
                }
                .keyboardShortcut(KeyEquivalent("z"), modifiers: [.command, .shift])
                .disabled(homeViewModel.undoManager.canRedo == false)
            }
        }
    }
    
    class AppDelegate: NSObject, NSApplicationDelegate {
        
        /// base Application settings
        /// need init once and send as param to another instances
        ///
        private var appSettings: AppSettingsProtocol = AppSettings()
        
        /// base App Store Manager
        /// need init once and send as param to another instances
        ///
        fileprivate var appStoreService: AppStoreProtocol = AppStoreService()
        
        /// base application object
        /// need setup everything inside that object to allow aadd unit tests
        ///
        private(set) lazy var app: Application = {
            .init()
        }()
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            app.setup()
        }
        
        func applicationDidBecomeActive(_ notification: Notification) {}
    }
}
