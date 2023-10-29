//
//  RSRCResource.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.08.2023.
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
