//
//  KSNumericTextFieldTests.swift
//  KSNumericTextFieldTests
//
//  Created by Lee Kah Seng on 17/03/2018.
//  Copyright © 2018 Lee Kah Seng. All rights reserved.
//

import XCTest
@testable import KSNumericTextField

class KSNumericTextFieldTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testValidInput() {
        
        let integerDigit = 5
        let fractionDigit = 3
        
        let textField = KSNumericTextField(withMaxIntegerDigit: integerDigit, maxFractionDigit: fractionDigit)
        
        // 1.3
        var inputText = "1.3"
        var expectedText = inputText
        
        var valid = textField.setText(inputText)
        var resultText = textField.text!
        
        XCTAssertTrue(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
        

        // 123
        inputText = "123"
        expectedText = inputText
        valid = textField.setText(inputText)
        resultText = textField.text!
        
        XCTAssertTrue(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
        
        
        // 0.234
        inputText = "0.234"
        expectedText = inputText
        valid = textField.setText(inputText)
        resultText = textField.text!
        
        XCTAssertTrue(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
        
        
        // 12345.123
        inputText = "12345.123"
        expectedText = inputText
        valid = textField.setText(inputText)
        resultText = textField.text!
        
        XCTAssertTrue(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
    }
    
    
    func testInValidInput() {
        
        let integerDigit = 3
        let fractionDigit = 2
        
        let textField = KSNumericTextField(withMaxIntegerDigit: integerDigit, maxFractionDigit: fractionDigit)
        
        // ABC
        var inputText = "ABC"
        var expectedText = ""
        
        var valid = textField.setText(inputText)
        var resultText = textField.text!
        
        XCTAssertFalse(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
        
        
        // 123
        inputText = "1234"
        expectedText = ""
        valid = textField.setText(inputText)
        resultText = textField.text!
        
        XCTAssertFalse(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
        
        
        // 0.234
        inputText = "0.999"
        expectedText = ""
        valid = textField.setText(inputText)
        resultText = textField.text!
        
        XCTAssertFalse(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
        
        
        // 12345.123
        inputText = "9123.444"
        expectedText = ""
        valid = textField.setText(inputText)
        resultText = textField.text!
        
        XCTAssertFalse(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
    }
    
    
    func testStartWithDecimalSeparator() {
    
        let integerDigit = 2
        let fractionDigit = 3
        
        let textField = KSNumericTextField(withMaxIntegerDigit: integerDigit, maxFractionDigit: fractionDigit)
        
        let inputText = ".23"
        let expectedText = "0.23"
        
        // Set inputText to textField & trigger end editing
        let valid = textField.setText(inputText)
        textField.textFieldDidEndEditing(textField)
        
        let resultText = textField.text!
        
        XCTAssertTrue(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
    }
    
    
    func testEndWithDecimalSeparator() {
        
        let integerDigit = 2
        let fractionDigit = 3
        
        let textField = KSNumericTextField(withMaxIntegerDigit: integerDigit, maxFractionDigit: fractionDigit)
        
        let inputText = "34."
        let expectedText = "34"
        
        // Set inputText to textField & trigger end editing
        let valid = textField.setText(inputText)
        textField.textFieldDidEndEditing(textField)
        
        let resultText = textField.text!
        
        XCTAssertTrue(valid)
        XCTAssertTrue(resultText == expectedText, "Expected \(expectedText), but get \(resultText)")
    }
}
