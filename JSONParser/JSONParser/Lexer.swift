//
//  Lexer.swift
//  JSONParser
//
//  Created by moon on 2018. 4. 17..
//  Copyright © 2018년 JK. All rights reserved.
//

import Foundation

enum Token {
    case number(Int)
    case text(String)
    case boolean(Bool)
}

class Lexer {
    enum Error: Swift.Error {
        case invalidCharacter(Character)
    }
    
    private let input: String
    private var position: String.Index
    private let openBracket: Character = "["
    private let closeBracket: Character = "]"
    private let comma: Character = ","
    
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
    
    func lex() throws -> [[Token]] {
        var tokens = [[Token]]()
        
        while let nextCharacter = self.peek() {
            switch nextCharacter {
            // array판단
            case openBracket:
                // array가져오기
                advance()
                try tokens.append(makeArrayTokens())
            default:
                throw Lexer.Error.invalidCharacter(nextCharacter)
            }
        }
        
        return tokens
    }
    
    // 배열일 경우 배열의 토큰 생성
    func makeArrayTokens() throws -> [Token] {
        var arrayTokens = [Token]()
        
        while let nextCharacter = self.peek() {
            switch nextCharacter {
            case "0"..."9":
                // 숫자 문자가 등장하면 나머지숫자가져오기
                let value = getNumber()
                arrayTokens.append(.number(value))
            case " ", comma:
                // 공백, "," 무시
                advance()
            case closeBracket:
                advance()
                return arrayTokens
            default:
                throw Lexer.Error.invalidCharacter(nextCharacter)
            }
        }
        
        return arrayTokens
    }
    
    func getNumber() -> Int {
        var value = 0
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "0"..."9":
                let digitValue = Int(String(nextCharacter))!
                value = 10 * value + digitValue
                advance()
            default:
                return value
            }
        }
        
        return value
    }
    
}
