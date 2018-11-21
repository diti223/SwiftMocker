//
//  FunctionTransformer.swift
//  SwiftMocker
//
//  Created by Adrian Bilescu on 29/10/2018.
//  Copyright © 2018 Bilescu. All rights reserved.
//

import Foundation

class FunctionTransformer {
    
    var invokedCountProperty: InvokedCountProperty {
        return InvokedCountProperty(name: "invoked\(functionName.capFirst)Count", type: "Int")
    }
    
    private(set) var parameterProperties: [ParameterProperty] = []
    private(set) var returnProperty: ReturnProperty?
    
    private var originalFunctionString: String
    private var functionName: String
    private var parametersString: String?
    private var returnString: String?
    init(rawInput: String) {
        self.functionName = rawInput
        self.originalFunctionString = rawInput
        cleanUpInput()
    }
    
    var mockedFunction: String {
        return mockDeclaration + "\n" + mockImplementation
    }
    
    private var mockDeclaration: String {
        var result = invokedCountProperty.declarationDescription
        
        if parameterProperties.count > 0 {
            result.addNewLine()
            let parametersResult = parameterProperties.map { property -> String in
                return property.declarationDescription
            }
            result.append(parametersResult.joined(separator: "\n"))
        }
        
        if let returnProperty = returnProperty, !returnProperty.isSelfType {
            result.addNewLine()
            result.append(returnProperty.declarationDescription)
        }
        
        return result
    }
    
    private var mockImplementation: String {
        var result = "\(originalFunctionString) {"
        result.addNewLineTab()
        result.append(invokedCountProperty.implementationDescription)
        
        
        if parameterProperties.count > 0 {
            result.addNewLine()
            let parametersResult = parameterProperties.map { property -> String in
                return "\t\(property.implementationDescription)"
            }
            result.append(parametersResult.joined(separator: "\n"))
        }
        
        if let returnProperty = returnProperty {
            result.addNewLineTab()
            result.append(returnProperty.implementationDescription)
        }
        result.append("\n}")
        return result
    }
    
    private func cleanUpInput() {
        extractReturnString()
        extractParametersString()
        clearFunctionPrefix()
        clearFunctionParentheses()
        removeInputWhiteLines()
        generateParametersProperties()
        generateReturnParameter()
    }
    
    private func generateReturnParameter() {
        guard let returnString = returnString else { return }
        let returnType = returnString.trimmingCharacters(in: .whitespaces)
        returnProperty = ReturnProperty(name: "\(functionName)DummyValue", type: returnType)
    }
    
    private func extractReturnString() {
        let indexOfFirstParenthesis = functionName.firstIndex(of: "(")!
        var openCloseParenthesisChecker = 0
        var endOfParametersIndex: String.Index?
        for enumeratedCharacter in functionName[indexOfFirstParenthesis..<functionName.endIndex].enumerated() {
            let character = enumeratedCharacter.element
            
            if character == "(" { openCloseParenthesisChecker += 1 }
            if character == ")" { openCloseParenthesisChecker -= 1 }
            if openCloseParenthesisChecker == 0 {
                endOfParametersIndex = functionName.index(indexOfFirstParenthesis, offsetBy: enumeratedCharacter.offset)
                break
            }
        }
        
        let startReturnIndex = endOfParametersIndex!
        let rawReturnString = String(functionName[startReturnIndex..<functionName.endIndex])
        functionName = String(functionName[...startReturnIndex])
        guard let endOfReturnSymbolIndex = rawReturnString.firstIndex(of: ">") else { return }
        
        returnString = String(rawReturnString[rawReturnString.index(after: endOfReturnSymbolIndex)..<rawReturnString.endIndex])
    }
    
    
    private func generateParametersProperties() {
        guard let parametersString = parametersString else { return }
        parameterProperties = ParameterProperty.createFromParamter(rawInput: parametersString, functionName: functionName)
    }
    
    private func extractParametersString() {
        let openParenthesisIndex = functionName.firstIndex(of: "(")!
        let closeParenthesisIndex = functionName.lastIndex(of: ")")!
        
        let startIndex = functionName.index(openParenthesisIndex, offsetBy: 1)
        let endIndex = functionName.index(closeParenthesisIndex, offsetBy: -1)
        
        guard startIndex < endIndex else {
            return
        }
        
        parametersString = String(functionName[startIndex...endIndex])
    }
    
    
    private func clearFunctionParentheses() {
        let openParenthesisIndex = functionName.firstIndex(of: "(")!
        functionName = String(functionName[functionName.startIndex..<openParenthesisIndex])
    }
    
    private func clearFunctionPrefix() {
        let prefixFuncRange = functionName.range(of: "func")!
        
        functionName = String(functionName[prefixFuncRange.upperBound..<functionName.endIndex])
    }
    
    private func removeInputWhiteLines() {
        functionName = functionName.replacingWhiteSpace()
    }
}

// MARK: - ParameterProperty
private extension ParameterProperty {
    static func createFromParamter(rawInput : String, functionName: String) -> [ParameterProperty] {
        let components = rawInput.split(separator: ":")
        let properties = components.dropLast().enumerated().compactMap { (enumerator) -> ParameterProperty? in
            let rawComponent = enumerator.element
            let nextComponent = components[enumerator.offset+1]
            return extractProperty(rawName: String(rawComponent), rawType: String(nextComponent), functionName: functionName)
        }
        return properties
    }
    
    static func extractProperty(rawName: String, rawType: String, functionName: String) -> ParameterProperty? {
        let parameterName = extractParameterName(fromRawName: rawName)
        let parameterType = extractParameterType(fromRawType: rawType)
        return composePropertyFrom(parameter: parameterName, type: parameterType, function: functionName)
    }
    
    static func extractParameterName(fromRawName rawName: String) -> String {
        var rawName = rawName
        if let lastCommaIndex = rawName.lastIndex(of: ",") {
            rawName = String(rawName[lastCommaIndex..<rawName.endIndex])
        }
        let parameterName = removingLabelFrom(parameterName: rawName).replacingWhiteSpace()
        return parameterName
    }
    
    static func extractParameterType(fromRawType rawType: String) -> String {
        var rawType = rawType
        if let lastCommaIndex = rawType.lastIndex(of: ","),
            !isEnclosedInParentheses(string: rawType) {
            rawType = String(rawType[rawType.startIndex..<lastCommaIndex])
            
        }
        rawType = replacingKeywords(fromParameterType: rawType)
        let parameterType = rawType.trimmingCharacters(in: .whitespaces)
        return parameterType
    }
    
    static func composePropertyFrom(parameter: String, type: String, function: String) -> ParameterProperty? {
        let capitalizedParameter = parameter.capFirst
        let capitalizedFunction = function.capFirst
        let propertyName: String
        if capitalizedFunction.hasSuffix(capitalizedParameter) {
            propertyName = capitalizedFunction
        } else {
            propertyName = capitalizedFunction + capitalizedParameter
        }
        return ParameterProperty(name: "invoked\(propertyName)", type: "\(type)", parameterName: parameter)
    }
    
    private static func removingLabelFrom(parameterName: String) -> String {
        guard let whiteSpaceIndex = parameterName.trimmingCharacters(in: .whitespaces).lastIndex(of: " ") else { return parameterName }
        return String(parameterName[whiteSpaceIndex..<parameterName.endIndex])
    }
    
    private static func isEnclosedInParentheses(string: String) -> Bool {
        let trimmedString = string.replacingWhiteSpace()
        
        guard let firstCharacter = trimmedString.first,
            let lastCharacter = trimmedString.last else {
            return false
        }
        return firstCharacter == "(" && lastCharacter == ")"
    }
    
    private static func replacingKeywords(fromParameterType parameterType: String) -> String {
        var parameterType = parameterType.replacingOccurrences(of: "@escaping", with: "")
        parameterType = parameterType.replacingOccurrences(of: "inout ", with: "")
        return parameterType
    }
}
