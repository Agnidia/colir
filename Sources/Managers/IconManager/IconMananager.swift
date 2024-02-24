//
//  IconMananager.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 05.05.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import CoreServices

enum IconManagerError: Error {
    case missedData
    case dummyFileNotCreated
    case scriptNotCreated
    case scriptNotExecuted
    case scriptError(String)
}

class IconManager {
    private enum K {
        static let iconsetName = "icon.iconset"
        static let icnsName = "icon.icns"
        
        static let iconutilPath = "/usr/bin/iconutil"
        static let iconutilFileType = "icns"
        
        static let scriptNotCreatedKey = "scriptNotCreated"
        static let scriptNotExecutedKey = "scriptNotExecuted"
    }
    
    private lazy var fs = FileManager.default
    private let serialQueue = DispatchQueue.global()
    
    private func createIconSet(for images: [NSImage], to url: URL) throws {
        // Create the iconset directory
        try fs.createDirectory(at: url, withIntermediateDirectories: true)
        
        // Write out all the icon files
        for dimension in [16, 32, 128, 256, 512] {
            for scale in [1, 2] {
                guard let image = images.first(where: { $0.size.width == CGFloat(dimension) }) else {
                    continue
                }
                
                let filename = "icon_\(dimension)x\(dimension)\(scale == 1 ? "" : "@\(scale)x").png"
                
                try image.pngData?.write(to: url.appendingPathComponent(filename))
            }
        }
    }
    
    func convertImagesToIcns(_ images: [NSImage]) throws -> Data {
        let tmpDir = fs.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let iconSetURL = tmpDir.appendingPathComponent(K.iconsetName)
        let iconURL = tmpDir.appendingPathComponent(K.icnsName)
        
        // Get the iconset of all the sized images
        try self.createIconSet(for: images, to: iconSetURL)
        
        // Now we need to convert to an icns
        let process = Process()
        let pipe = Pipe()
        
        process.standardOutput = pipe
        process.standardError = pipe
        process.arguments = ["-c", K.iconutilFileType, iconSetURL.lastPathComponent]
        
        process.launchPath = K.iconutilPath
        process.currentDirectoryPath = tmpDir.path
        process.launch()
        process.waitUntilExit()
        
        if process.terminationStatus != .zero {
            print("FAILED")
        }
        
        let data = try Data(contentsOf: iconURL)
        try? fs.removeItem(at: tmpDir)
        return data
    }
    
    func setIcon(data: Data, to path: URL) throws {
        let filePath = fs.temporaryDirectory.appendingPathComponent(K.icnsName)
        
        do {
            try data.write(to: filePath)
        } catch {
            throw IconManagerError.dummyFileNotCreated
        }
        
        let p = filePath.path
        
        let myAppleScript = """
use framework "Foundation"
use framework "AppKit"
use scripting additions

set fromPosix to "\(p)" -- whatever
set toPosix to "\(path.path)"
set theImage to (current application's NSImage's alloc()'s initWithContentsOfFile:fromPosix)
(current application's NSWorkspace's sharedWorkspace()'s setIcon:theImage forFile:toPosix options:0)
"""
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            let semaphore = DispatchSemaphore(value: 0)
            serialQueue.async {
                let value = scriptObject.executeAndReturnError(&error).stringValue
                if value != "true" {
                    error = NSDictionary(object: K.scriptNotExecutedKey, forKey: NSAppleScript.errorMessage as NSCopying)
                }
                semaphore.signal()
            }
            semaphore.wait()
        } else {
            error = NSDictionary(object: K.scriptNotExecutedKey, forKey: NSAppleScript.errorMessage as NSCopying)
        }
        
        try? fs.removeItem(at: filePath)
        
        if let message = error?[NSAppleScript.errorMessage] as? String {
            if message == K.scriptNotCreatedKey {
                throw IconManagerError.scriptNotCreated
            } else if message == K.scriptNotExecutedKey {
                throw IconManagerError.scriptNotExecuted
            } else {
                throw IconManagerError.scriptError(message)
            }
        }
    }
}
