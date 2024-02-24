//
//  TokenManager.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 17.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import Foundation

final class TokenManager {
    
    func getSystem() -> String? {
        let platformExpert = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        
        guard let uuidCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0) else {
            return nil
        }
        
        IOObjectRelease(platformExpert)
        
        return uuidCFString.takeUnretainedValue() as? String
    }
}
