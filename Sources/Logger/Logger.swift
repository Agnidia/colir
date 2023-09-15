//
//  Logger.swift
//  colir
//
//  Created by Vitalii P on 23.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
import os

struct Log {
    
    enum Category: String {
        case application
        case database
        case fileStorage
    }
    
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    private let logger: Logger!
    
    init(category: Category) {
        logger = Logger(subsystem: Log.subsystem, category: category.rawValue)
    }
    
    func debug(_ message: String) {
        logger.debug("\(message)")
    }
    
    func info(_ message: String) {
        logger.info("\(message)")
    }
    
    func error(_ message: String) {
        logger.error("\(message)")
    }
    
    /// display execution time in seconds  of function
    func elapsedTime(startAt: CFAbsoluteTime, finishAt: CFAbsoluteTime = CFAbsoluteTimeGetCurrent(), file: String = #fileID, function: String = #function) {
        var path = file
        if let f = file.split(separator: "/").last, let fileName = f.split(separator: ".").first {
            path = String(fileName)
        }
        
        logger.info("[\(path): \(function)] execution took: \((finishAt - startAt) * 1000)s")
    }
}
