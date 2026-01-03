//
//  RSRCFileParser.swift
//
//  Created on 15.09.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Foundation

/// A class responsible for parsing resource files from a given URL.
///
/// This class reads and parses resource files, returning an array of `RSRCResource` objects.
final class RSRCFileParser {
    /// Parses a resource file at the specified URL.
    ///
    /// - Parameter url: The URL of the resource file to be parsed.
    /// - Returns: An array of `RSRCResource` objects parsed from the resource file.
    /// - Throws: An error if the resource file cannot be read or parsed.
    ///
    /// This method utilizes `ResourceFile.read(from:)` to read the contents of the file
    /// and convert it into an array of `RSRCResource` objects. If the file cannot be accessed
    /// or if there is an issue with parsing, it will throw an appropriate error.
    func parse(url: URL) throws -> [RSRCResource] {
        try ResourceFile.read(from: url)
    }
}
