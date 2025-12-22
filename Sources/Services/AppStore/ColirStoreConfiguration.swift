//
//  ColirStoreConfiguration.swift
//
//  Created on 18.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import DeveloperSupportStore
import Foundation

/// Colir app-specific store configuration implementing StoreConfigurationProtocol.
///
/// This configuration provides the product IDs, URLs, and styling for the
/// DeveloperSupportStore package to match the Colir app's design.
public struct ColirStoreConfiguration: StoreConfigurationProtocol {

    // MARK: - URLs

    public var privacyPolicyURL: URL {
        URL(string: "https://igrsoft.com/info/app/colir/policy.html")!
    }

    public var termsOfUseURL: URL {
        URL(string: "https://igrsoft.com/info/app/colir/terms.html")!
    }

    public var isLoggingEnabled: Bool { false }
    
    // MARK: - Initialization

    public init() {}
}
