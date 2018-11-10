//
//  ReturnProperty.swift
//  SwiftMocker
//
//  Created by Adrian-Dieter Bilescu on 11/10/18.
//  Copyright © 2018 Bilescu. All rights reserved.
//

import Foundation

struct ReturnProperty: Property {
    let name: String
    let type: String
    
    var declarationDescription: String {
        if isOptionalType {
            return "var \(name): \(type)"
        }
        
        return "var \(name): \(type)?"
    }
    
    var implementationDescription: String {
        var result = "return \(name)"
        if !isOptionalType {
            result.append("!")
        }
        return result
    }
}
