//
//  CodeGenerator.swift
//  ZZZZ
//
//  Created by Hare Sudhan on 10/12/17.
//  Copyright © 2017 ZZZZ. All rights reserved.
//

import Foundation

enum ZDataType : String {
    case unknown = "Any"
    case dict
    case array = "[Any]"
    case int = "Int"
    case double = "Double"
    case string = "String"
}

struct ZStruct {
    
    var name : ZDataType
    var swiftType : String{
        get{
            return name.rawValue
        }
    }
    
    init(value: Any) {
        let rawValue = String(describing: type(of: (value)))
        switch rawValue {
        case "__NSDictionaryI":
            name = .dict
            break
        case "NSTaggedPointerString","__NSCFString":
            name = .string
            break
        case "NSNull":
            name = .unknown
            break
        case "__NSArrayI":
            name = .array
            break
        case "Int":
            name = .int
            break
        case "Double":
            name = .double
            break
        default :
            name = .unknown
            break
        }
    }
}

struct CodeGenerator{
    
    fileprivate static func getVariablesandDataTypes(_ jsonDict : [String:Any]) -> ([String],[String],String){
        var dataTypes = [String]()
        var variables = [String]()
        var codingKeys = [String]()
        
        var allKeys = Array(jsonDict.keys)
        var allValues = Array(jsonDict.values)
        var count = allKeys.count
        
        var modelStr = ""
        
        while count != 0 {
            let key = allKeys.removeFirst()
            var value = allValues.removeFirst()
            variables.append(key.nameVariables())
            codingKeys.append(key)
            modelStr += ("var " + key.nameVariables() + " : \t")
            
            if let x = Double(String(describing:value)){
                if rint(x) == x && !String(describing:value).contains("."){
                    value = Int(x)
                }else{
                    value = x
                }
            }
            
            let dataTypeValue : String
            let dataType = ZStruct(value: value)
            if(dataType.name == .dict){
                dataTypeValue = key.nameDataModel()
                print("\nstruct \(key.nameDataModel()) : Codable {")
                print(self.convertJsonDictToModel((value as? [String:Any])!))
                print("}")
                
            }else{
                dataTypeValue = (dataType.swiftType)
            }
            
            dataTypes.append(dataTypeValue)
            modelStr += dataTypeValue + "?\n"
            count -= 1
        }
        
        modelStr = modelStr.formatCode(":", 0)
        
        //Adding Coding Keys
        var codingKeyStr = ""
        
        for i in 0..<variables.count{
            codingKeyStr += "case " + variables[i] + " = " + "\"" + codingKeys[i] +  "\"\n"
        }
        
        modelStr += "\n\tenum CodingKeys: String, CodingKey { \n\n" + codingKeyStr.formatCode("=", 2) + "\n \t}"
        
        //Encodable Conformance

        var encodableStr = "\nvar container = encoder.container(keyedBy: CodingKeys.self) \n"
        
        for i in 0..<variables.count{
            encodableStr += "try container.encode(" + variables[i] + ", forKey: ." + variables[i] +  ")\n"
        }
        
        modelStr += "\n\nfunc encode(to encoder: Encoder) throws { \n" + encodableStr + "\n \t}\n\n"
        
        //Decodable Conformance
        
        var decodableStr = "\nlet values = try decoder.container(keyedBy: CodingKeys.self) \n"
        
        for i in 0..<variables.count{
            decodableStr += (variables[i]) + " = try values.decode(" + dataTypes[i] + ".self, forKey: ." + variables[i] + ") \n"
        }
        
        modelStr += "\tinit(from decoder: Decoder) throws { \n" + decodableStr.formatCode("=", 2) + "\n \t}"

        return (variables,dataTypes,modelStr)
        
    }
    
    static func convertJsonDictToModel(_ jsonDict: [String:Any]) -> String{
        let (_,_,modelStr) = getVariablesandDataTypes(jsonDict)
        return modelStr
    }
    
}

public extension String{
    var dict :  [String:Any]?{
        guard let data = self.data(using: .utf8),let json = try? JSONSerialization.jsonObject(with: data, options: []),let jsonDict : [String:Any]  = json as? [String:Any] else{
            return nil
        }
        return (jsonDict)
    }
}

fileprivate extension String {
    
    
    func capitalize() -> String{
        return prefix(1).uppercased() + dropFirst()
    }
    
    
    func nameDataModel() -> String{
        var fullNameArr = self.components(separatedBy: "_")
        var str =  ""
        for i in 0..<fullNameArr.count{
            str += fullNameArr[i].capitalize()
        }
        return str
    }
    
    func nameVariables() -> String{
        var fullNameArr = self.components(separatedBy: "_")
        var str =  fullNameArr[0]
        for i in 1..<fullNameArr.count{
            str += fullNameArr[i].capitalize()
        }
        return str
        
    }
    
    func formatCode(_ separator : Character,_ tabSpaces : Int) -> String{
        let strComponents = self.components(separatedBy: "\n")
        var maxIndex = 0
        for i in strComponents{
            if let index = i.index(of: separator){
                let temp = index.encodedOffset
                if(temp > maxIndex){
                    maxIndex = temp
                }
            }
        }
        var modelStr = ""
        for i in strComponents{
            if let index = i.index(of: separator){
                let temp = index.encodedOffset
                if(temp < maxIndex){
                    
                    let substrings = i.components(separatedBy: String(separator))
                    
                    modelStr += (String(repeating: "\t", count: tabSpaces) + substrings[0] + String(repeating: " ", count: maxIndex-temp) + String(separator) + substrings[1] + "\n")
                }else{
                    modelStr += String(repeating: "\t", count: tabSpaces) + i + "\n"
                }
            }
        }
        
        return (modelStr)
    }
    
}
