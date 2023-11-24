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
    
    var appSettings: AppSettingsProtocol
    
    let appStoreService: AppStoreProtocol
    
    let iconManager: IconManager
    
    init(appSettings: AppSettingsProtocol, appStoreService: AppStoreProtocol, iconManager: IconManager = .init()) {
        self.appSettings = appSettings
        self.appStoreService = appStoreService
        self.iconManager = iconManager
    }
    
    var canExport: Bool {
        Int(appSettings.exportCount.value) ?? 0 > 0 || appStoreService.hasFullAccess
    }
    
    func export(image: ImageDto) {
        
        guard let url = image.url else {
            return
        }
        
        do {
            let icnsData = try iconManager.convertImagesToIcns(image.outputImages)
            try iconManager.setIcon(data: icnsData, to: url)
        } catch {
            return
        }
        
        if appStoreService.hasFullAccess == false {
            let exportCount = (Int(appSettings.exportCount.value) ?? 0)
            appSettings.exportCount = CryptoModel(value: "\(exportCount - 1)")
        }
    }
}


final class ExportIconManagerPreview: ExportIconManagerProtocol {
    var canExport: Bool {
        false
    }
    
    func export(image: ImageDto) {}
}
