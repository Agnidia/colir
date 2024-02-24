//
//  String+Crypto.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 17.11.2023.
//  Copyright © 2023 IGR Software. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    
    func aesEncrypt(key: String, 
                    keyLength: size_t = kCCKeySizeAES128,
                    iv: String = "",
                    options: CCOptions = CCOptions(kCCOptionPKCS7Padding),
                    algoritm: CCAlgorithm = CCAlgorithm(kCCAlgorithmAES128)) -> String? {
        
        if let keyData = key.data(using: String.Encoding.utf8),
           let data = self.data(using: String.Encoding.utf8),
           let cryptData = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {
            
            var numBytesEncrypted: size_t = 0
            
            let cryptStatus = CCCrypt(CCOperation(kCCEncrypt),
                                      algoritm,
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
    
    func aesDecrypt(key: String,
                    keyLength: size_t = kCCKeySizeAES128,
                    iv: String = "",
                    options: CCOptions = CCOptions(kCCOptionPKCS7Padding),
                    algoritm: CCAlgorithm = CCAlgorithm(kCCAlgorithmAES128)) -> String? {
        
        if let keyData = key.data(using: String.Encoding.utf8),
           let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
           let cryptData = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(CCOperation(kCCDecrypt),
                                      algoritm,
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
            let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
            
            return unencryptedMessage
        }
        
        return nil
    }
}
