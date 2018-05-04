//
//  OutputView.swift
//  JSONParser
//
//  Created by moon on 2018. 4. 18..
//  Copyright © 2018년 JK. All rights reserved.
//

import Foundation

protocol JSONPrintable {
    func totalDataCountDescription() -> String
    func countDataDescription() -> String
    func validateJSONData() -> String
    func makeJSONObjectFormat(indent: Int, _ jsonObject: [String:JSONDataValue]) -> String
    func makeJSONArrayFormat(indent: Int, _ jsonArrayData: [JSONDataValue]) -> String
}

struct OutputView {
    static func printJSONData(_ jsonData: JSONPrintable) {
        print("\(jsonData.totalDataCountDescription())\(jsonData.countDataDescription())가 포함되어 있습니다.")
        print(jsonData.validateJSONData())
    }
}

extension JSONPrintable {
    
    func makeJSONObjectFormat(indent: Int, _ jsonObject: [String:JSONDataValue]) -> String {
        var result: String = "{"
        for (key, jsonDataValue) in jsonObject {
            result += "\n"
            result += String(repeating: "\t", count: indent)
            switch jsonDataValue {
            case .boolean(let value):
                result += "\(key): \(value),"
            case .characters(let value):
                result += "\(key): \"\(value)\","
            case .number(let value):
                result += "\(key): \(value),"
            case .object(let value):
                result += "\(key): "
                result += "\(self.makeJSONObjectFormat(indent: indent + 1, value)),"
            case .array(let value):
                result += "\(key): "
                result += "\(self.makeJSONArrayFormat(indent: indent + 1, value)),"
            }
        }
        result.removeLast()
        result += "\n"
        result += String(repeating: "\t", count: indent - 1)
        result += "}"
        return result
    }
    
    func makeJSONArrayFormat(indent: Int, _ jsonArrayData: [JSONDataValue]) -> String {
        var result = "["
        for jsonData in jsonArrayData {
            switch jsonData {
            case .boolean(let value):
                result += "\(value), "
            case .characters(let value):
                result += "\"\(value)\", "
            case .number(let value):
                result += "\(value), "
            case .array(let value):
                result += "\t\(self.makeJSONArrayFormat(indent: indent + 1, value)), "
            case .object(let value):
                result += "\(self.makeJSONObjectFormat(indent: indent + 1, value)), "
            }
        }
        result.removeLast(2)
        if indent == 1 {
            result += "\n"
        }
        result += "]"
        return result
    }
}
