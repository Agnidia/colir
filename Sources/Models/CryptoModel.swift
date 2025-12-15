//
//  CryptoModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 17.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import Foundation

/// A model that represents encrypted/decrypted data using AES encryption.
public struct CryptoModel {
    fileprivate var key: String = "ColirToken"

    var value: String

    init(value: String) {
        self.value = value
    }
}

extension CryptoModel: RawRepresentable {
    public init?(rawValue: String) {
        // Decrypt the raw value to get the original string
        guard let result = (rawValue + "==").aesDecrypt(key: key) else {
            return nil
        }

        self = CryptoModel(value: result)
    }

    // Encrypt the value and remove padding characters
    public var rawValue: String {
        guard let val = value.aesEncrypt(key: key), val.isEmpty == false else { return "" }

        return String(val[val.startIndex ..< val.index(val.endIndex, offsetBy: -2)])
    }
}
