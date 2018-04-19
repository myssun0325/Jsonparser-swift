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
    
    func lex() throws -> [String] {
        var tokens = [String]()
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            // array판단
            case openBracket:
                // array가져오기
                advance()
                let listToken = makeListToken()
                tokens += listToken
            case openCurlyBracket:
                let objectToken = makeObjectToken()
                tokens += objectToken
            default:
                throw Lexer.Error.invalidCharacter(nextCharacter)
            }
        }
        
        return tokens
    }
    
    // array 토큰, 구분 comma
    private func makeListToken() -> [String] {
        var listToken = [String]()
        var tokenCarrier = "" // listToken에 의미있는 문자열단위(토큰) 전달
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case comma:
                // 콤마를 만나면 하나의 토큰으로 구분하여 토큰배열에 저장
                listToken.append(tokenCarrier)
                tokenCarrier.removeAll()
                advance()
            case space:
                advance()
            case closeBracket: // list 마지막 판단, 반환
                advance()
                listToken.append(tokenCarrier)
                return listToken
            default:
                tokenCarrier += String(nextCharacter)
                advance()
            }
        }
        return listToken
    }
    
    // object 토큰, 구분 comma
    func makeObjectToken() -> [String] {
        var objectToken = [String]()
        var tokenCarrier = ""
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case comma:
                objectToken.append(tokenCarrier)
                tokenCarrier.removeAll()
                advance()
            case space:
                advance()
            case closeCurlyBracket: // object 마지막 판단
                tokenCarrier += String(nextCharacter)
                advance()
                objectToken.append(tokenCarrier)
                return objectToken
            default:
                tokenCarrier += String(nextCharacter)
                advance()
            }
        }
        return objectToken
    }
}
