//
//  RSRCResource.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

class RSRCResource: NSObject {
    public var data: Data?
    
    var image: NSImage? {
        guard let data else {
            return nil
        }
            
        return NSImage(data: data)
    }
    
    @objc init(data: Data? = nil) {
        self.data = data
    }
}
