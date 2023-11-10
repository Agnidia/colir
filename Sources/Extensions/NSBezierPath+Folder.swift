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
    
    static func folderLines() {
        //// Color Declarations
        let gradientColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.118)
        let gradientColor2 = NSColor(red: 0, green: 0, blue: 0, alpha: 0.02)

        //// Gradient Declarations
        let gradient = NSGradient(colors: [gradientColor2, gradientColor2.blended(withFraction: 0.5, of: gradientColor2)!, gradientColor2, gradientColor2.blended(withFraction: 0.5, of: gradientColor2)!, gradientColor2, gradientColor], atLocations: [0.0, 0.03, 0.32, 0.38, 0.45, 1.0], colorSpace: NSColorSpace.sRGB)!

        //// Rectangle Drawing
        let rectanglePath = NSBezierPath()
        rectanglePath.move(to: NSPoint(x: 40, y: 189))
        rectanglePath.line(to: NSPoint(x: 984, y: 189))
        rectanglePath.line(to: NSPoint(x: 984, y: 209))
        rectanglePath.line(to: NSPoint(x: 40, y: 209))
        rectanglePath.line(to: NSPoint(x: 40, y: 189))
        rectanglePath.close()
        gradient.draw(in: rectanglePath, angle: -90)


        //// Rectangle 2 Drawing
        let rectangle2Path = NSBezierPath()
        rectangle2Path.move(to: NSPoint(x: 45, y: 152.5))
        rectangle2Path.line(to: NSPoint(x: 978, y: 152))
        rectangle2Path.line(to: NSPoint(x: 983, y: 172))
        rectangle2Path.line(to: NSPoint(x: 41, y: 172))
        rectangle2Path.line(to: NSPoint(x: 45, y: 152.5))
        rectangle2Path.close()
        gradient.draw(in: rectangle2Path, angle: -90)
    }
    
    static func folderBottomShadow() {
        
        //// Color Declarations
        let gradient2Color = NSColor(red: 0, green: 0, blue: 0, alpha: 0.118)
        let gradient2Color3 = NSColor(red: 1, green: 1, blue: 1, alpha: 0.004)

        //// Gradient Declarations
        let gradient2 = NSGradient(starting: gradient2Color3, ending: gradient2Color)!

        //// Bezier 2 Drawing
        let bezier2Path = NSBezierPath()
        bezier2Path.move(to: NSPoint(x: 40, y: 238))
        bezier2Path.line(to: NSPoint(x: 984, y: 238))
        bezier2Path.line(to: NSPoint(x: 984, y: 182))
        bezier2Path.curve(to: NSPoint(x: 904, y: 106), controlPoint1: NSPoint(x: 984, y: 182), controlPoint2: NSPoint(x: 982, y: 106))
        bezier2Path.curve(to: NSPoint(x: 120, y: 106), controlPoint1: NSPoint(x: 826, y: 106), controlPoint2: NSPoint(x: 120, y: 106))
        bezier2Path.curve(to: NSPoint(x: 40, y: 182), controlPoint1: NSPoint(x: 120, y: 106), controlPoint2: NSPoint(x: 40, y: 106))
        bezier2Path.curve(to: NSPoint(x: 40, y: 238), controlPoint1: NSPoint(x: 40, y: 258), controlPoint2: NSPoint(x: 40, y: 238))
        bezier2Path.close()
        gradient2.draw(in: bezier2Path, angle: -90)

    }
}
