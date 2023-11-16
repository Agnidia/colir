//
//  RSRCFileParser.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 07.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

final class RSRCFileParser {
    public func parse(url: URL) throws -> [RSRCResource] {
        return try ResourceFile.read(from: url)
    }
}
