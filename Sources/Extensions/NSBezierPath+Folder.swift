//
//  NSBezierPath+Folder.swift
//  fsdfsd
//
//  Created by Vitalii P on 08.11.2023.
//

import AppKit

extension NSBezierPath {
    static var folderCenterFrame: NSBezierPath {
        let bezierPath = NSBezierPath()
        
        //top-left
        bezierPath.move(to: NSPoint(x: 904, y: 768))
        
        //top-right
        bezierPath.curve(to: NSPoint(x: 986, y: 690),
                         controlPoint1: NSPoint(x: 904, y: 768),
                         controlPoint2: NSPoint(x: 986, y: 768))
        //right-top
        bezierPath.curve(to: NSPoint(x: 986, y: 182),
                         controlPoint1: NSPoint(x: 986, y: 182),
                         controlPoint2: NSPoint(x: 986, y: 182))
        //right-bottom
        bezierPath.curve(to: NSPoint(x: 904, y: 108),
                         controlPoint1: NSPoint(x: 986, y: 182),
                         controlPoint2: NSPoint(x: 986, y: 108))
        //bottom-right
        bezierPath.curve(to: NSPoint(x: 120, y: 108),
                         controlPoint1: NSPoint(x: 120, y: 108),
                         controlPoint2: NSPoint(x: 120, y: 108))
        //bottom-left
        bezierPath.curve(to: NSPoint(x: 38, y: 182),
                         controlPoint1: NSPoint(x: 120, y: 108),
                         controlPoint2: NSPoint(x: 38, y: 108))
        //left-bottom
        bezierPath.curve(to: NSPoint(x: 38, y: 690),
                         controlPoint1: NSPoint(x: 38, y: 256),
                         controlPoint2: NSPoint(x: 38, y: 690))
        //left-top
        bezierPath.curve(to: NSPoint(x: 120, y: 768),
                         controlPoint1: NSPoint(x: 38, y: 768),
                         controlPoint2: NSPoint(x: 38, y: 768))
        //top-left
        bezierPath.curve(to: NSPoint(x: 904, y: 768),
                         controlPoint1: NSPoint(x: 120, y: 768),
                         controlPoint2: NSPoint(x: 904, y: 768))
        
        return bezierPath
    }
}
