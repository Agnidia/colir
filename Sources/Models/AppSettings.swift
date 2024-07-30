//
//  AppSettings.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// Protocol defining methods and properties for application settings.
public protocol AppSettingsProtocol {
    
    /// Sets up the application settings with a unique identifier.
    /// - Parameter uuid: A unique identifier for setup.
    func setup(uuid: String)
    
    /// Data used for storing bookmarks.
    var bookmarkData: Data { get set }
    
    /// Path to the user’s Pictures directory.
    var userPicturesPath: URL { get set }
    
    /// Indicates whether the application is running in test mode.
    var isTestMode: Bool { get }
    
    /// The count of exported items, represented by a `CryptoModel`.
    var exportCount: CryptoModel { get set }
}

class AppSettings: AppSettingsProtocol, ObservableObject {
    // MARK: - Constants
    
    private enum Key {
        static let bookmarkData = "BookmarkData"
        static let userPicturesPath = "UserPicturesPath"
        static let exportCount = "ExportCount"
        static let isTestMode = "IsTestMode"
    }
    
    private enum K {
        fileprivate static var userPicturesUrl: URL {
            let userHomeDirectory = URL(fileURLWithPath: "/Users/\(NSUserName())")
            return userHomeDirectory.appendingPathComponent("Pictures", isDirectory: true)
        }
    }
    
    // MARK: - Dependency Injection
    
    private static var userDefaults: UserDefaults!
    
    // MARK: - Initialization
    
    /// Initializes `AppSettings` with a specified `UserDefaults` suite.
    /// - Parameter store: The `UserDefaults` instance to use.
    init(store: UserDefaults = .init(suiteName: Secrets.userDefaultsId)!) {
        AppSettings.userDefaults = store
    }
    
    func setup(uuid: String) {
        // Implement setup logic if needed.
    }
    
    // MARK: - Properties
    
    /// Access data for Xcode data folder.
    @AppStorage(Key.bookmarkData, store: userDefaults)
    var bookmarkData: Data = Data()
    
    /// URL for the user’s Pictures directory.
    @AppStorage(Key.userPicturesPath, store: userDefaults)
    var userPicturesPath: URL = K.userPicturesUrl
    
    /// Count of exported items.
    @AppStorage(Key.exportCount, store: userDefaults)
    var exportCount: CryptoModel = CryptoModel(value: "1")
    
    /// Indicates whether the application is running in test mode.
    var isTestMode: Bool {
#if DEBUG
        true
#else
        false
#endif
    }
}

extension AppSettings {
    /// A preview instance of `AppSettings` for testing purposes.
    static var preview: AppSettings = .init(store: UserDefaults(suiteName: Secrets.userDefaultsId + ".preview")!)
}
