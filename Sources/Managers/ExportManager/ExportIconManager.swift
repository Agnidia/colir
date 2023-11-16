//
//  ExportIconManager.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 12.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
import AppKit

public protocol ExportIconManagerProtocol {
    var canExport: Bool { get }
    
    func export(image: ImageDto)
}

final class ExportIconManager: ExportIconManagerProtocol {
    
    let appSettings: AppSettingsProtocol
    
    let appStoreService: AppStoreProtocol
    
    init(appSettings: AppSettingsProtocol, appStoreService: AppStoreProtocol) {
        self.appSettings = appSettings
        self.appStoreService = appStoreService
    }
    
    var canExport: Bool {
        false//self.appSettings.exportCount > 0 || appStoreService.hasFullAccess
    }
    
    func export(image: ImageDto) {
        
    }
}


final class ExportIconManagerPreview: ExportIconManagerProtocol {
    var canExport: Bool {
        false
    }
    
    func export(image: ImageDto) {}
}
