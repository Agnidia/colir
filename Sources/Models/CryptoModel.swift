//
//  CryptoModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 17.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import Foundation

public struct CryptoModel {
    fileprivate var key: String = TokenManager().getSystem() ?? "Token23"
    
    var value: String
    
    init(value: String) {
        self.value = value
    }
}

extension CryptoModel: RawRepresentable {
    public init?(rawValue: String) {
        guard let result = (rawValue + "==").aesDecrypt(key: key) else {
            return nil
        }
        
        self = CryptoModel(value: result)
    }

    public var rawValue: String {
        guard let val = value.aesEncrypt(key: key), val.isEmpty == false else { return "" }
        
        return String(val[val.startIndex..<val.index(val.endIndex, offsetBy:-2)])
    }
}
