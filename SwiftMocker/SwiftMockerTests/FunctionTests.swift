//
//  FunctionTests.swift
//  FunctionTests
//
//  Created by Adrian-Dieter Bilescu on 11/3/18.
//  Copyright © 2018 Bilescu. All rights reserved.
//

import XCTest

class FunctionTests: XCTestCase {

    var sut: FunctionTransformer!
    
    func testOneWordFunction_CountParameterName() {
        makeSubject(with: "create()")
        
        let expected = "invokedCreateCount"
        let actual = sut.invokedCountProperty.name
        XCTAssertEqual(expected, actual)
    }
    
    func testOneWordFunction_CountParameterTypeString() {
        makeSubject(with: "create()")
        
        let expected = "Int"
        let actual = sut.invokedCountProperty.type
        XCTAssertEqual(expected, actual)
    }
    
    func testTwoWordsFunction_CountParameterName() {
        makeSubject(with: "createCar()")
        
        let expected = "invokedCreateCarCount"
        let actual = sut.invokedCountProperty.name
        XCTAssertEqual(expected, actual)
    }
    
    func testOneParameterFunction_CountParameterName() {
        makeSubject(with: "fetchUserRegisterStateUseCase(handler: FetchUserRegisterStatePresentation)")
        
        let expected = "invokedFetchUserRegisterStateUseCaseCount"
        let actual = sut.invokedCountProperty.name
        XCTAssertEqual(expected, actual)
    }
    
    func testOneParameterFunction_PropertyMockName() {
        makeSubject(with: "fetchUserRegisterStateUseCase(handler: FetchUserRegisterStatePresentation)")
        
        let expected = "invokedFetchUserRegisterStateUseCaseHandler"
        let actual = sut.parameterProperties.first!.name
        XCTAssertEqual(expected, actual)
    }
    
    
    func testOneParameterFunction_PropertyMockType() {
        makeSubject(with: "fetchUserRegisterStateUseCase(handler: FetchUserRegisterStatePresentation)")
        
        let expected = "FetchUserRegisterStatePresentation"
        let actual = sut.parameterProperties.first!.type
        XCTAssertEqual(expected, actual)
    }
    
    func testOneTupleParameterFunction_CountPropertyName() {
        makeSubject(with: "fetchUserRegisterStateUseCase(handler: (String, String?, String.Index))")
        
        let expected = "invokedFetchUserRegisterStateUseCaseCount"
        let actual = sut.invokedCountProperty.name
        XCTAssertEqual(expected, actual)
    }
    
    func testOneTupleParameterFunction_PropertyMockType() {
        makeSubject(with: "fetchUserRegisterStateUseCase(handler: (String, String?, String.Index))")
        
        let expected = "(String, String?, String.Index)"
        let actual = sut.parameterProperties.first!.type
        XCTAssertEqual(expected, actual)
    }
    
    func testOneTupleParameterFunction_PropertyMockName() {
        makeSubject(with: "fetchUserRegisterStateUseCase(handler: (String, String?, String.Index))")
        
        let expected = "invokedFetchUserRegisterStateUseCaseHandler"
        let actual = sut.parameterProperties.first!.name
        XCTAssertEqual(expected, actual)
    }
    
    func testTwoTuplesParameterFunction_PropertyMockType() {
        makeSubject(with: "fetchUserRegisterStateUseCase(handler: (String, String?, String.Index), request: (Int?, Error))")
        
        let expectedNameP1 = "invokedFetchUserRegisterStateUseCaseHandler"
        let expectedTypeP1 = "(String, String?, String.Index)"
        let expectedNameP2 = "invokedFetchUserRegisterStateUseCaseRequest"
        let expectedTypeP2 = "(Int?, Error)"
        let actualNameP1 = sut.parameterProperties.first!.name
        let actualTypeP1 = sut.parameterProperties.first!.type
        let actualNameP2 = sut.parameterProperties[1].name
        let actualTypeP2 = sut.parameterProperties[1].type
        XCTAssertEqual(expectedNameP1, actualNameP1)
        XCTAssertEqual(expectedTypeP1, actualTypeP1)
        XCTAssertEqual(expectedNameP2, actualNameP2)
        XCTAssertEqual(expectedTypeP2, actualTypeP2)
    }
    
    func testCompletionParameter_PropertyMockName() {
        makeSubject(with: "checkPurchaseStatus(completion: @escaping (Result<PaymentStatus>) -> ())")
        
        let expected = "invokedCheckPurchaseStatusCompletion"
        let actual = sut.parameterProperties.first!.name
        XCTAssertEqual(expected, actual)
    }
    
    func testCompletionParameter_PropertyMockType() {
        makeSubject(with: "checkPurchaseStatus(completion: @escaping (Result<PaymentStatus>) -> ())")
        
        let expected = "(Result<PaymentStatus>) -> ()"
        let actual = sut.parameterProperties.first!.type
        XCTAssertEqual(expected, actual)
    }
    
    func testCompletionParameterNoSpacing_PropertyMockType() {
        makeSubject(with: "checkPurchaseStatus(completion:@escaping(Result<PaymentStatus>)->())")
        
        let expected = "(Result<PaymentStatus>)->()"
        let actual = sut.parameterProperties.first!.type
        XCTAssertEqual(expected, actual)
    }
    
    
    func testOneParameterFunctionExtraSpacing_PropertyMockName() {
        makeSubject(with: "  fetchUserRegisterStateUseCase  (  handler  :   FetchUserRegisterStatePresentation)  ")
        
        let expected = "invokedFetchUserRegisterStateUseCaseHandler"
        let actual = sut.parameterProperties.first!.name
        XCTAssertEqual(expected, actual)
    }
    
    func testOneParameterFunctionNoSpacing_PropertyMockName() {
        makeSubject(with: "fetchUserRegisterStateUseCase(handler:FetchUserRegisterStatePresentation)")
        
        let expected = "invokedFetchUserRegisterStateUseCaseHandler"
        let actual = sut.parameterProperties.first!.name
        XCTAssertEqual(expected, actual)
    }
    
    func testOneHiddenParameterFunction_PropertyMockName() {
        makeSubject(with: "fetchUserRegisterStateUseCase(  _    handler:   FetchUserRegisterStatePresentation  )")
        
        let expected = "invokedFetchUserRegisterStateUseCaseHandler"
        let actual = sut.parameterProperties.first!.name
        XCTAssertEqual(expected, actual)
    }
    
    func testOneLabeledParameterFunction_PropertyMockName() {
        makeSubject(with: "fetchUserRegisterStateUseCase(  with    handler  :   FetchUserRegisterStatePresentation  )")
        
        let expected = "invokedFetchUserRegisterStateUseCaseHandler"
        let actual = sut.parameterProperties.first!.name
        XCTAssertEqual(expected, actual)
    }
    
    func testTwoParameterFunction_ShouldCreateTwoProperties() {
        makeSubject(with: "fetchUserRegisterStateUseCase(handler: FetchUserRegisterStatePresentation, request: FetchUserRegisterRequest)")
        
        let expected = 2
        let actual = sut.parameterProperties.count
        XCTAssertEqual(expected, actual)
    }
    
    func testTwoLabeledParameterFunction_PropertyNames() {
        makeSubject(with: "fetchUserRegisterStateUseCase(with handler:FetchUserRegisterStatePresentation,usingRequest request: FetchUserRegisterRequest)")
        
        let expectedNameP1 = "invokedFetchUserRegisterStateUseCaseHandler"
        let actualNameP1 = sut.parameterProperties.first!.name
        let expectedNameP2 = "invokedFetchUserRegisterStateUseCaseRequest"
        let actualNameP2 = sut.parameterProperties[1].name
        XCTAssertEqual(expectedNameP1, actualNameP1)
        XCTAssertEqual(expectedNameP2, actualNameP2)
    }
    
    func testReturnParameterOfFunction_PropertyCountName() {
        makeSubject(with: "fetchUser() -> User")
        
        let expected = "invokedFetchUserCount"
        let actual = sut.invokedCountProperty.name
        XCTAssertEqual(expected, actual)
    }
    
    func testReturnParameterOfFunction_PropertyName() {
        makeSubject(with: "fetchUser() -> User")
        
        let expected = "fetchUserDummyValue"
        let actual = sut.returnProperty!.name
        XCTAssertEqual(expected, actual)
    }
    
    func testReturnParameterOfFunction_PropertyType() {
        makeSubject(with: "fetchUser() -> User")
        
        let expected = "User"
        let actual = sut.returnProperty!.type
        XCTAssertEqual(expected, actual)
    }
    
    func testReturnParameterOfFunctionWithCompletion_ReturnPropertyType() {
        makeSubject(with: "fetchUser(completion: (Result<User>)->()) -> Bool")
        
        let expected = "Bool"
        let actual = sut.returnProperty!.type
        XCTAssertEqual(expected, actual)
    }
    
    
    //MARK: -
    func testFunctionWithReturnFunction() {
        makeSubject(with: "fetchUser(completion: (Result<User>)->()) -> (Bool)->()")
        
        let expected = "(Bool)->()"
        let actual = sut.returnProperty!.type
        XCTAssertEqual(expected, actual)
    }
    
    func testFunctionWithInternalAccessControl() {
        sut = FunctionTransformer(rawInput: "internal func myAwesomeFunction()")
        
        XCTAssertEqual("invokedMyAwesomeFunctionCount", sut.invokedCountProperty.name)
        XCTAssertEqual("Int", sut.invokedCountProperty.type)
    }
    
    func testFunctionWithPrivateAccessControl() {
        sut = FunctionTransformer(rawInput: "private func myAwesomeFunction()")
        
        XCTAssertEqual("invokedMyAwesomeFunctionCount", sut.invokedCountProperty.name)
        XCTAssertEqual("Int", sut.invokedCountProperty.type)
    }
    
    func testFunctionWithPublicAccessControl() {
        sut = FunctionTransformer(rawInput: "public func myAwesomeFunction()")
        
        XCTAssertEqual("invokedMyAwesomeFunctionCount", sut.invokedCountProperty.name)
        XCTAssertEqual("Int", sut.invokedCountProperty.type)
    }
    
    func testFunctionWithPublicOpenAccessControl() {
        sut = FunctionTransformer(rawInput: "open public func myAwesomeFunction()")
        
        XCTAssertEqual("invokedMyAwesomeFunctionCount", sut.invokedCountProperty.name)
        XCTAssertEqual("Int", sut.invokedCountProperty.type)
    }
    
    func testFunctionWithPublicObjcAccessControl() {
        sut = FunctionTransformer(rawInput: "@objc public func myAwesomeFunction()")
        
        XCTAssertEqual("invokedMyAwesomeFunctionCount", sut.invokedCountProperty.name)
        XCTAssertEqual("Int", sut.invokedCountProperty.type)
    }
    
    func testSimpleFunction_CountPropertyDeclartionTypeShouldBeNonOptional() {
        makeSubject(with: "simplifyName()")
        let expected = "var invokedSimplifyNameCount = 0"
        let actual = sut.invokedCountProperty.declarationDescription
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSimpleFunction_CountImplementation() {
        makeSubject(with: "simplifyName()")
        let expected = "invokedSimplifyNameCount += 1"
        let actual = sut.invokedCountProperty.implementationDescription
        
        XCTAssertEqual(expected, actual)
    }
    
    func testOptionalReturnValue_ImplementationReturnValueOptional() {
        makeSubject(with: "handleConfigFile(response: ConfigFileResponse) -> Int")
        
        let expected = "return handleConfigFileDummyValue!"
        let actual = sut.returnProperty!.implementationDescription
        XCTAssertEqual(expected, actual)
    }
    
    func testReturnValue_ImplementationReturnValueUnwrapped() {
        makeSubject(with: "handleConfigFile(response: ConfigFileResponse) -> Int?")
        
        let expected = "return handleConfigFileDummyValue"
        let actual = sut.returnProperty!.implementationDescription
        XCTAssertEqual(expected, actual)
    }
    
    //MARK: - Parameter Property Suffix
    
    func testFunctionNameSuffixEqualToParameterName_ShouldAppearOnceInParamaterProperty() {
        makeSubject(with: "handleConfigFile(file: ConfigFile)")
        
        let expected = "invokedHandleConfigFile"
        let actual = sut.parameterProperties.first?.name
        XCTAssertEqual(expected, actual)
    }
    
    func testFunctionNameSuffixEqualToParameterName_ParameterHiddenName_ShouldAppearOnceInParamaterProperty() {
        makeSubject(with: "handleConfigFile(_ file: ConfigFile)")
        
        let expected = "invokedHandleConfigFile"
        let actual = sut.parameterProperties.first?.name
        XCTAssertEqual(expected, actual)
    }
    
    func testFunctionNameSuffixEqualToParameterName_ParameterLabeled_ShouldAppearOnceInParamaterProperty() {
        makeSubject(with: "handleConfigFile(file configFile: ConfigFile)")
        
        let expected = "invokedHandleConfigFile"
        let actual = sut.parameterProperties.first?.name
        XCTAssertEqual(expected, actual)
    }
    
    
    func testFunction_MockDescription() {
        makeSubject(with: "handleConfigFile(response: ConfigFileResponse, completion: ()->()) -> Int")
        
        let expected = "var invokedHandleConfigFileCount = 0\nvar invokedHandleConfigFileResponse: ConfigFileResponse?\nvar invokedHandleConfigFileCompletion: ()->()?\nvar handleConfigFileDummyValue: Int?\nfunc handleConfigFile(response: ConfigFileResponse, completion: ()->()) -> Int {\n\tinvokedHandleConfigFileCount += 1\n\tinvokedHandleConfigFileResponse = response\n\tinvokedHandleConfigFileCompletion = completion\n\treturn handleConfigFileDummyValue!\n}"
        let actual = sut.mockedFunction
        XCTAssertEqual(expected, actual)
    }
    
    //MARK: -
    func testOptionalParameter_ShouldCreateOptionalProperty() {
        makeSubject(with: "handleFileResult(result: File?)")
        
        let expected = "var invokedHandleFileResult: File?"
        let actual = sut.parameterProperties.first?.declarationDescription
        
        XCTAssertEqual(expected, actual)
    }
    
    func testOptionalReturnType_ShouldCreateOptionalProperty() {
        makeSubject(with: "fileResult() -> File?")
        
        let expected = "var fileResultDummyValue: File?"
        let actual = sut.returnProperty?.declarationDescription
        
        XCTAssertEqual(expected, actual)
    }
    
    private func makeSubject(with input: String) {
        sut = FunctionTransformer(rawInput: "func \(input)")
    }
    
}
