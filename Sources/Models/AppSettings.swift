//
//  AppSettings.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// User and application settings model
/// 
public protocol AppSettingsProtocol {
    
    var bookmarkData: Data { get set }
    var userPicturesPath: URL { get set }
    
    var isTestMode: Bool { get }
}

class AppSettings: AppSettingsProtocol, ObservableObject {
    // MARK: - Constants
    private enum Key {
        // Access Data
        static let bookmarkData = "BookmarkData"
        static let userPicturesPath = "UserPicturesPath"
        
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
    
    // MARK: - Init
    
    init(store: UserDefaults = .init(suiteName: Secrets.userDefaultsId)!) {
        AppSettings.userDefaults = store
    }
    
    // MARK: - Variables
    
    // access data for Xcode data folder
    @AppStorage(Key.bookmarkData, store: userDefaults) var bookmarkData: Data = Data()
    @AppStorage(Key.userPicturesPath, store: userDefaults) var userPicturesPath: URL = K.userPicturesUrl
    
    var hasAccessToXcodeData: Bool {
        bookmarkData.isEmpty == false
    }
    
    var hasValidPathToXcodeData: Bool {
        userPicturesPath == K.userPicturesUrl
    }
    
    // test mode switcher
    var isTestMode: Bool {
#if DEBUG
        true
#else
        false
#endif
    }
}

extension AppSettings {
    static var preview: AppSettings = .init(store: UserDefaults(suiteName: Secrets.userDefaultsId + ".preview")!)
}
