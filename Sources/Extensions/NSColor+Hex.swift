import AppKit

extension String  {
    func conformsTo(pattern: String) -> Bool {
        let pattern = NSPredicate(format:"SELF MATCHES %@", pattern)
        return pattern.evaluate(with: self)
    }
}

extension NSColor {
    
    public convenience init(hex: Int, alpha: CGFloat = 1) {
        let (red, green, blue) = NSColor.intToRGB(value: UInt64(hex))
        self.init(calibratedRed: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex: String, alpha: CGFloat = 1) {
        // Handle two types of literals: 0x and # prefixed
        var cleanedString = ""
        if hex.hasPrefix("0x") {
            cleanedString = String(hex.suffix(from: hex.index(hex.startIndex, offsetBy: 2)))
        } else if hex.hasPrefix("#") {
            cleanedString = String(hex.suffix(from: hex.index(hex.startIndex, offsetBy: 1)))
        }
        
        // Ensure it only contains valid hex characters 0
        let validHexPattern = "[a-fA-F0-9]+"
        if cleanedString.conformsTo(pattern: validHexPattern) {
            var theInt: UInt64 = 0
            let scanner = Scanner(string: cleanedString)
            scanner.scanHexInt64(&theInt)
            
            let (red, green, blue) = NSColor.intToRGB(value: theInt)
            
            self.init(calibratedRed: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.init(calibratedRed: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    private static func intToRGB(value: UInt64) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        let red = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((value & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((value & 0xFF)) / 255.0
        
        return (r: red, g: green, b: blue)
    }
}
