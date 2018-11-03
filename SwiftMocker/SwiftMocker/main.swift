//
//  main.swift
//  SwiftMocker
//
//  Created by Adrian-Dieter Bilescu on 11/3/18.
//  Copyright © 2018 Bilescu. All rights reserved.
//

import Foundation
import AppKit

typealias Variable = [String: String]

func readFile() throws -> String {
    if let url = Bundle.main.url(forResource: "Functions", withExtension: "in") {
        return try String(contentsOf: url, encoding: .utf8)
    }
    return ""
}

func writeFile(content: String) throws {
    
    let url = Bundle.main.bundleURL.appendingPathComponent("Functions.out")
    if !FileManager.default.isWritableFile(atPath: url.absoluteString) {
        FileManager.default.createFile(atPath: url.path, contents: content.data(using: .utf8))
    } else {
        try content.write(to: url, atomically: false, encoding: .utf8)
    }
    NSWorkspace.shared.openFile(url.path)
}

let fileContent = try! readFile()
var strings = fileContent.split(separator: Character("\n")).map { String($0) }

let result = strings.map { FunctionTransformer(rawInput: $0).mockedFunction }.joined(separator: "\n\n")

try? writeFile(content: result)
print(result)

