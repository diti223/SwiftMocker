//
//  Property.swift
//  SwiftMocker
//
//  Created by Adrian-Dieter Bilescu on 11/10/18.
//  Copyright © 2018 Bilescu. All rights reserved.
//

import Foundation

protocol Property {
    var name: String { get }
    var type: String { get }
    var declarationDescription: String { get }
}

extension Property {
    var isOptionalType: Bool {
        return type.hasSuffix("?")
    }
}
