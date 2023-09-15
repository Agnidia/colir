//
//  AppSettings.swift
//  colir
//
//  Created by Vitalii P on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// User and application settings model
/// 
protocol AppSettingsProtocol {
    
    var isTestMode: Bool { get }
}

class AppSettings: AppSettingsProtocol, ObservableObject {
    // MARK: - Constants
    private enum Key {
        static let isTestMode = "isTestMode"
    }
    
    // MARK: - Dependency Injection
    
    private static var userDefaults: UserDefaults!
    
    // MARK: - Init
    
    init(store: UserDefaults = .init(suiteName: Secrets.userDefaultsId)!) {
        AppSettings.userDefaults = store
    }
    
    // MARK: - Variables
    
    // test mode switcher
    var isTestMode: Bool {
#if DEBUG
        true
#else
        false
#endif
    }
}
