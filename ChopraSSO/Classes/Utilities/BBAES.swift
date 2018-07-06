//
//  BBAES.swift
//  ChopraSSO
//
//  Created by Horti Tamás on 2018. 07. 05..
//

import Foundation
import CryptoSwift

extension String {
    func bb_AESDecryptedStringForIV(iv: Data?, key: Data?) -> String? {
        guard let data = BBAES.decryptedDataFromString(self, IV: iv, key: key) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

class BBAES {
    static func decryptedDataFromString(_ string: String, IV iv: Data?, key: Data?) -> Data? {
        guard let data: Data = Data(base64Encoded: string),
            let decryptedData: Data = decryptedDataFromData(data, iv: iv, key: key) else {
            return nil
        }
        
        return decryptedData;
    }
    
    static func decryptedDataFromData(_ data: Data?, iv: Data?, key: Data?) -> Data? {
        guard let data = data, let key = key,
            [16, 24, 32].contains(key.count)
            else { return nil }
        
        let encryptedData: Data
        var checkedIv: Array<UInt8> = []
        if let iv = iv, iv.count == 16 {
            encryptedData = data
            checkedIv = Array<UInt8>(iv)
        } else {
            let ivLength = 16
            checkedIv = Array<UInt8>(data.subdata(in: 0..<ivLength))
            encryptedData = data.subdata(in: ivLength..<(data.count - ivLength))
        }

        guard let decryptor: AES = try? AES(key: Array<UInt8>(key), blockMode: BlockMode.CBC(iv: Array<UInt8>(checkedIv)), padding: Padding.pkcs7),
            let decryptedData = try? decryptor.decrypt(Array<UInt8>(encryptedData))
            else {
            return nil
        }
    
        return Data(decryptedData)
    }
}
