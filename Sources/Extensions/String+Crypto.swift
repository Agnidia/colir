//
//  String+Crypto.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 17.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import CommonCrypto
import Foundation

extension String {
    /// Encrypts the string using AES encryption.
    ///
    /// - Parameters:
    ///   - key: The encryption key as a string.
    ///   - keyLength: The length of the encryption key. Default is `kCCKeySizeAES128`.
    ///   - iv: The initialization vector as a string. Default is an empty string.
    ///   - options: The encryption options. Default is `kCCOptionPKCS7Padding`.
    ///   - algorithm: The encryption algorithm. Default is `kCCAlgorithmAES128`.
    /// - Returns: The encrypted string in base64 format, or `nil` if encryption fails.
    func aesEncrypt(key: String,
                    keyLength: size_t = kCCKeySizeAES128,
                    iv: String = "",
                    options: CCOptions = CCOptions(kCCOptionPKCS7Padding),
                    algorithm: CCAlgorithm = CCAlgorithm(kCCAlgorithmAES128)) -> String?
    {
        if let keyData = key.data(using: .utf8),
           let data = data(using: .utf8),
           let cryptData = NSMutableData(length: Int(data.count) + kCCBlockSizeAES128)
        {
            var numBytesEncrypted: size_t = 0

            let cryptStatus = CCCrypt(CCOperation(kCCEncrypt),
                                      algorithm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            guard cryptStatus == kCCSuccess else {
                return nil
            }

            cryptData.length = numBytesEncrypted
            let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)

            return base64cryptString
        }

        return nil
    }

    /// Decrypts the string using AES encryption.
    ///
    /// - Parameters:
    ///   - key: The decryption key as a string.
    ///   - keyLength: The length of the decryption key. Default is `kCCKeySizeAES128`.
    ///   - iv: The initialization vector as a string. Default is an empty string.
    ///   - options: The decryption options. Default is `kCCOptionPKCS7Padding`.
    ///   - algorithm: The decryption algorithm. Default is `kCCAlgorithmAES128`.
    /// - Returns: The decrypted string, or `nil` if decryption fails.
    func aesDecrypt(key: String,
                    keyLength: size_t = kCCKeySizeAES128,
                    iv: String = "",
                    options: CCOptions = CCOptions(kCCOptionPKCS7Padding),
                    algorithm: CCAlgorithm = CCAlgorithm(kCCAlgorithmAES128)) -> String?
    {
        if let keyData = key.data(using: .utf8),
           let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
           let cryptData = NSMutableData(length: Int(data.length) + kCCBlockSizeAES128)
        {
            var numBytesEncrypted: size_t = 0

            let cryptStatus = CCCrypt(CCOperation(kCCDecrypt),
                                      algorithm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            guard cryptStatus == kCCSuccess else {
                return nil
            }

            cryptData.length = numBytesEncrypted
            let unencryptedMessage = String(data: cryptData as Data, encoding: .utf8)

            return unencryptedMessage
        }

        return nil
    }
}
