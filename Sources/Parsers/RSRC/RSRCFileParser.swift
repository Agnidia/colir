//
//  RSRCFileParser.swift
//  colir
//
//  Created by Vitalii P on 07.08.2023.
//

import Foundation

final class RSRCFileParser {
    public func parse(url: URL) throws -> [RSRCResource] {
        return try ResourceFile.read(from: url)
    }
}
