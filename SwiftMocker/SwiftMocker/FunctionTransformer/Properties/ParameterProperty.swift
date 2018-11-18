//
//  ParameterProperty.swift
//  SwiftMocker
//
//  Created by Adrian-Dieter Bilescu on 11/10/18.
//  Copyright © 2018 Bilescu. All rights reserved.
//

import Foundation

struct ParameterProperty: Property {
    
    let name: String
    let type: String
    private let parameterName: String
    
    init(name: String, type: String, parameterName: String) {
        self.name = name
        self.type = type
        self.parameterName = parameterName
    }
    
    var declarationDescription: String {
        if isOptionalType {
            return "var \(name): \(type)"
        }
        return "var \(name): \(type)?"
    }
    
    var implementationDescription: String {
        return "\(name) = \(parameterName)"
    }
}
