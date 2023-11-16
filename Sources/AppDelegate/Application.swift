//
//  Application.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 11.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

protocol ApplicationProtocol {
    
    var appSettings: AppSettingsProtocol { get }
    
    var appStoreService: AppStoreProtocol { get }
}

class Application {
    
    private let log: LogProtocol = Log(category: .application)
    
    init() {
        log.info("init")
    }
    
    /// main setup of base objects
    ///
    func setup() {
        log.info("setup")
    }
}
