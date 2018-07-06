//
//  RTSerializer.swift
//  ChopraSSO
//
//  Created by Horti Tamás on 2018. 07. 04..
//

import Foundation

enum RTError: Error {
    case deserializeError(String)
}

class RTSerializer {
    
    private var _index: String.Index!
    
    func serialize(_ object: Any, isString str: String) -> String {
        var strBuffer = str
        
        if let array = object as? [Any] {
            strBuffer = String(format: "%@a:%d:{", strBuffer, array.count)
            for item in array.enumerated() {
                strBuffer = serialize(NSNumber(value: item.offset), isString: strBuffer)
                strBuffer = serialize(item.element, isString: strBuffer)
            }
            strBuffer += "}" // it was "{" in previous version
            
            return strBuffer
        } else if let dictionary = object as? NSDictionary {
            strBuffer = String(format: "%@a:%d:{", dictionary.allKeys.count)
            for item in dictionary {
                strBuffer = serialize(item.key, isString: strBuffer)
                strBuffer = serialize(item.value, isString: strBuffer)
            }
            strBuffer += "}"
            
            return strBuffer
        } else if let number = object as? NSNumber {
            return String(format: "%@i:%d;", strBuffer, number.intValue)
        } else if let string = object as? String {
            return String(format: "%@s:%d:\"%@\";", strBuffer, string.count, string)
        } else {
            return strBuffer
        }
    }
    
    func deserialize(_ str: String?) -> Any? {
        let result = deserializeObject(str)
        
        return result.object
    }
    
    // MARK: - Submethods
    
    private func deserializeObject(_ string: String?) -> (str: String?, object: Any?) {
        do {
            guard var str = string, !str.isEmpty, !str.starts(with: "N") else {
                throw RTError.deserializeError("Empty object!")
            }
            
            let objectKey = str[str.startIndex..<str.index(str.startIndex, offsetBy: 2)]
            str = String(str.dropFirst(2))
            
            switch objectKey {
            case "i:":
                
                let intResult = try deserializeInt(str, endKey: ";")
                return (intResult.str, intResult.intValue)
                
            case "s:":
                
                let intResult = try deserializeInt(str, endKey: ":")
                str = String(intResult.str.dropFirst()) // drop '\"'
                
                let object = str[str.startIndex..<str.index(str.startIndex, offsetBy: min(intResult.intValue, str.distance(from: str.startIndex, to: str.endIndex)))]
                str = String(str.dropFirst(object.count + 1 + 1)) // drop '\";'
                return (str, object)
                
            case "a:":
                
                let intResult = try deserializeInt(str, endKey: ":")
                str = String(intResult.str.dropFirst()) // drop '{'
                
                let resultDictionary: NSMutableDictionary = NSMutableDictionary(capacity: intResult.intValue)
                for _ in 0..<intResult.intValue {
                    let result = try deserializeListObject(str)
                    str = result.str
                    
                    resultDictionary[result.item.key] = result.item.value //.addEntries(from: [result.item.key: result.item.value])
                }
                
                return (string, resultDictionary)
                
            default:
                throw RTError.deserializeError("Unknown object key!")
            }
        } catch {
            return (string, nil)
        }
    }
    
    private func deserializeInt(_ str: String?, endKey: Character) throws -> (str: String, intValue: Int) {
        guard var str = str, !str.isEmpty else {
            throw RTError.deserializeError("Could not deserialize Int!")
        }
        guard let endIndex = str.index(of: endKey), let object = Int(str[str.startIndex..<endIndex]) else {
            throw RTError.deserializeError("Could not deserialize Int!")
        }
        
        str = String(str.dropFirst(str.distance(from: str.startIndex, to: endIndex) + 1)) // drop ';'
        return (str, object)
    }
    
    private func deserializeListObject(_ str: String?) throws -> (str: String, item: (key: AnyHashable, value: Any)) {
        guard var str = str, !str.isEmpty else {
            throw RTError.deserializeError("Could not deserialize List object!")
        }
        
        let keyResult = deserializeObject(str)
        guard let keyResultStr = keyResult.str, let keyResultObject = keyResult.object as? AnyHashable else {
            throw RTError.deserializeError("Could not deserialize List object key!")
        }
        str = keyResultStr
        
        let valueResult = deserializeObject(str)
        guard let valueResultStr = valueResult.str, let valueResultObject = valueResult.object else {
            throw RTError.deserializeError("Could not deserialize List object value!")
        }
        str = valueResultStr
        
        return (str, (keyResultObject, valueResultObject))
    }
}
