//
//  InvokedCountProperty.swift
//  SwiftMocker
//
//  Created by Adrian-Dieter Bilescu on 11/10/18.
//  Copyright © 2018 Bilescu. All rights reserved.
//

import Foundation

struct InvokedCountProperty: Property {
    let name: String
    let type: String
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    var declarationDescription: String {
        return "var \(name) = 0"
    }
    
    var implementationDescription: String {
        return "\(name) += 1"
    }
}
