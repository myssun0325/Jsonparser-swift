//
//  Lexer.swift
//  JSONParser
//
//  Created by moon on 2018. 4. 17..
//  Copyright © 2018년 JK. All rights reserved.
//

import Foundation

class Lexer {
    enum Error: Swift.Error {
        case invalidCharacter(Character)
        case invalidBooleanCharacter
        
        var errorMessage: String {
            switch self {
            case .invalidBooleanCharacter:
                return "Boolean input was wrong!"
            case .invalidCharacter(let character):
                return "Input contained an invalid character: \(character)"
            }
        }
    }
    
    private let input: String
    private var position: String.Index
    private let openBracket: Character = "["
    private let closeBracket: Character = "]"
    private let comma: Character = ","
    private let space: Character = " "
    private let openCurlyBracket: Character = "{"
    private let closeCurlyBracket: Character = "}"
    private let colon: Character = ":"
    
    init(input: String) {
        self.input = input
        self.position = input.startIndex
    }
    
    // 입력된 문자를 확인.
    private func peek() -> Character? {
        guard self.position < input.endIndex else {
            return nil
        }
        return input[self.position]
    }
    
    // 다음 문자로 체크하기 위해 index 이동
    private func advance() {
        self.position = self.input.index(after: self.position)
    }
    
    func lex() throws -> TokenData {
        var tokens: [String] = [String]()
        var tokenCarrier = "" // valueToken에 의미있는 문자열단위(토큰) 전달
        var isSavingCharacters = false
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case comma:
                if !tokenCarrier.isEmpty{ tokens.append(tokenCarrier) }
                tokenCarrier.removeAll()
            case "\"":
                tokenCarrier.append(nextCharacter)
                isSavingCharacters = !isSavingCharacters
            case space:
                if isSavingCharacters {
                    tokenCarrier.append(nextCharacter)
                }
            case colon, closeCurlyBracket, closeBracket:
                if !tokenCarrier.isEmpty {
                    tokens.append(tokenCarrier)
                    tokenCarrier.removeAll()
                }
                tokens.append(String(nextCharacter))
            case openBracket,openCurlyBracket:
                tokens.append(String(nextCharacter))
            default:
                tokenCarrier.append(nextCharacter)
            }
            advance()
        }
        
        return TokenData(tokens: tokens)
    }
}
