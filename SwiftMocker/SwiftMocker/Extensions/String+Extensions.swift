//
//  String+Extensions.swift
//  SwiftMocker
//
//  Created by Adrian-Dieter Bilescu on 11/10/18.
//  Copyright © 2018 Bilescu. All rights reserved.
//

import Foundation

extension String {
    var capFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    func replacingWhiteSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    mutating func addNewLine() {
        self.append("\n")
    }
    
    mutating func addNewLineTab() {
        self.append("\n\t")
    }
}
