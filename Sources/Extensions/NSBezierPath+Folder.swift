//
//  NSBezierPath+Folder.swift
//  fsdfsd
//
//  Created by Vitalii P on 08.11.2023.
//

import AppKit

extension NSBezierPath {
    static var folderCenterFrame: NSBezierPath {
        let rectanglePath = NSBezierPath()
        rectanglePath.move(to: NSPoint(x: 151, y: 768))
        rectanglePath.line(to: NSPoint(x: 872, y: 768))
        rectanglePath.curve(to: NSPoint(x: 934, y: 762), 
                            controlPoint1: NSPoint(x: 904, y: 768),
                            controlPoint2: NSPoint(x: 920, y: 768))
        
        rectanglePath.line(to: NSPoint(x: 937, y: 761))
        rectanglePath.curve(to: NSPoint(x: 977, y: 721),
                            controlPoint1: NSPoint(x: 956, y: 755),
                            controlPoint2: NSPoint(x: 970, y: 740))
        rectanglePath.curve(to: NSPoint(x: 983, y: 656),
                            controlPoint1: NSPoint(x: 983, y: 704),
                            controlPoint2: NSPoint(x: 983, y: 688))
        
        rectanglePath.line(to: NSPoint(x: 983, y: 220))
        rectanglePath.curve(to: NSPoint(x: 978, y: 158), 
                            controlPoint1: NSPoint(x: 983, y: 188),
                            controlPoint2: NSPoint(x: 983, y: 172))
        
        rectanglePath.line(to: NSPoint(x: 977, y: 155))
        rectanglePath.curve(to: NSPoint(x: 937, y: 115), 
                            controlPoint1: NSPoint(x: 970, y: 136),
                            controlPoint2: NSPoint(x: 956, y: 122))
        rectanglePath.curve(to: NSPoint(x: 872, y: 110), 
                            controlPoint1: NSPoint(x: 920, y: 110),
                            controlPoint2: NSPoint(x: 904, y: 110))
        
        rectanglePath.line(to: NSPoint(x: 151, y: 110))
        rectanglePath.curve(to: NSPoint(x: 90, y: 114), 
                            controlPoint1: NSPoint(x: 120, y: 110),
                            controlPoint2: NSPoint(x: 104, y: 110))
        
        rectanglePath.line(to: NSPoint(x: 87, y: 115))
        rectanglePath.curve(to: NSPoint(x: 47, y: 155), 
                            controlPoint1: NSPoint(x: 68, y: 122),
                            controlPoint2: NSPoint(x: 54, y: 136))
        rectanglePath.curve(to: NSPoint(x: 41, y: 220), 
                            controlPoint1: NSPoint(x: 41, y: 172),
                            controlPoint2: NSPoint(x: 41, y: 188))
        
        rectanglePath.line(to: NSPoint(x: 41, y: 656))
        rectanglePath.curve(to: NSPoint(x: 46, y: 718.19), 
                            controlPoint1: NSPoint(x: 41, y: 688),
                            controlPoint2: NSPoint(x: 41, y: 704))
        
        rectanglePath.line(to: NSPoint(x: 46, y: 721))
        rectanglePath.curve(to: NSPoint(x: 87, y: 761),
                            controlPoint1: NSPoint(x: 54, y: 740),
                            controlPoint2: NSPoint(x: 68, y: 755))
        rectanglePath.curve(to: NSPoint(x: 151, y: 768), 
                            controlPoint1: NSPoint(x: 104, y: 768),
                            controlPoint2: NSPoint(x: 120, y: 768))
        rectanglePath.close()
        
        return rectanglePath
    }
}
