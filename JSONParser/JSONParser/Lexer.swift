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

struct Lexer {
    let input: String
    var position: String.Index
    
    init(input: String) {
        self.input = input
        self.position = input.startIndex
    }
}
