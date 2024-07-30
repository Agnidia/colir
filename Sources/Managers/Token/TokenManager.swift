//
//  TokenManager.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 17.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import Foundation
import IOKit

final class TokenManager {

    /// Retrieves the system UUID as a string.
    ///
    /// - Returns: The system UUID as a string, or `nil` if it cannot be retrieved.
    func getSystem() -> String? {
        // Obtain the platform expert service
        let platformExpert = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        
        // Check if the platformExpert service was successfully obtained
        guard platformExpert != 0 else {
            return nil
        }
        
        // Retrieve the UUID property from the platform expert
        guard let uuidCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0)?.takeUnretainedValue() as? String else {
            IOObjectRelease(platformExpert)
            return nil
        }
        
        // Release the platform expert service object
        IOObjectRelease(platformExpert)
        
        return uuidCFString
    }
}
