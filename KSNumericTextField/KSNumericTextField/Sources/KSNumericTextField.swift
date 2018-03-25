//
//  KSNumericTextField.swift
//  KS-Firebase-Playground
//
//  Created by Lee Kah Seng on 14/03/2017.
//  Copyright © 2018 Lee Kah Seng. All rights reserved. (https://github.com/LeeKahSeng/KSNumericTextField)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

// Note: Currently have know issue where cursor will go to end of text everytime user type on it. Refer this for solution http://stackoverflow.com/questions/34922331/getting-and-setting-cursor-position-of-uitextfield-and-uitextview-in-swift

import UIKit

@objc public protocol KSNumericTextFieldDelegate {
    
    @available(iOS 2.0, *)
    @objc optional func textFieldShouldBeginEditing(_ textField: KSNumericTextField) -> Bool
    
    @available(iOS 2.0, *)
    @objc optional func textFieldDidBeginEditing(_ textField: KSNumericTextField)
    
    @available(iOS 2.0, *)
    @objc optional func textFieldShouldEndEditing(_ textField: KSNumericTextField) -> Bool
    
    @available(iOS 2.0, *)
    @objc optional func textFieldDidEndEditing(_ textField: KSNumericTextField)
    
    @available(iOS 2.0, *)
    @objc optional func textField(_ textField: KSNumericTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    
    @available(iOS 2.0, *)
    @objc optional func textFieldShouldClear(_ textField: KSNumericTextField) -> Bool
    
    @available(iOS 2.0, *)
    @objc optional func textFieldShouldReturn(_ textField: KSNumericTextField) -> Bool
    
    @available(iOS 10.0, *)
    @objc optional func textFieldDidEndEditing(_ textField: KSNumericTextField, reason: UITextFieldDidEndEditingReason)
}

public class KSNumericTextField: UITextField {
    
    public var numericTextFieldDelegate: KSNumericTextFieldDelegate?
    
    @IBInspectable var maxWholeNumberDigit: Int = 3
    @IBInspectable var maxDecimalDigit: Int = 2
    
    private let separator = Locale.current.decimalSeparator!
    
    override public var text: String? {
        get {
            return super.text
        }
        
        set {
            if isValid(newValue, maxWholeNumberDigit: maxWholeNumberDigit, maxDecimalDigit: maxDecimalDigit, decimalSeparator: separator) {
                
                // String format is valid
                super.text = newValue
            }
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    convenience init(withMaxWholeNumberDigit digit: Int, maxDecimalDigit decimalDigit: Int) {
        self.init(frame: CGRect.zero)
        
        maxWholeNumberDigit = digit
        maxDecimalDigit = decimalDigit
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        
        let isTextValid = isValid(super.text, maxWholeNumberDigit: maxWholeNumberDigit, maxDecimalDigit: maxDecimalDigit, decimalSeparator: separator)
        if !isTextValid {
            // Remove string in textField when invalid string was set in interface builder
            super.text = ""
        }
    }
    
    
    // Note: Override delegate to make sure super.delegate is always self
    override public var delegate: UITextFieldDelegate? {
        get {
            return super.delegate
        }
        
        set {
            if let d = newValue, d.isKind(of: KSNumericTextField.self) {
                super.delegate = newValue
            }
        }
    }
}

// MARK:- Public functions
extension KSNumericTextField {
    
    /// Set string to textField and return boolean to indicate the string is it in valid format
    ///
    /// - Parameter value: string to set to textField
    /// - Returns: true: string is valid, false: string is invalid
    public func setText(_ value: String?) -> Bool {
        
        text = value
        return text == value
    }
}

// MARK:- Private functions
extension KSNumericTextField {
    
    private func commonInit() {
        
        keyboardType = .decimalPad
        delegate = self
    }
    
    /// Check is the string a valid numeric value
    ///
    /// - Parameters:
    ///   - string: string to validate
    ///   - wholeNumberDigit: maximum whole number digit allow
    ///   - decimalDigit: maximum decimal digit allow
    ///   - separator: decimal separator
    /// - Returns: is the string have valid numeric value
    private func isValid(_ string: String?, maxWholeNumberDigit wholeNumberDigit: Int, maxDecimalDigit decimalDigit: Int, decimalSeparator separator: String) -> Bool {
        
        guard let value = string else {
            return false
        }
        
        let pattern = "^\\d{0,\(wholeNumberDigit)}(\\\(separator)\\d{0,\(decimalDigit)})?$"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let result = regex.matches(in: value, options: [], range: NSMakeRange(0, value.count))
            
            return (result.count > 0)
            
        } catch {
            return false
        }
    }
    
    /// Use to process the string after text field finish editing. Mainly to handle condition where separator at start / end of string
    ///
    /// - Parameter textFieldString: text value of textField
    /// - Returns: the processed string
    private func processStringAfterEndEditing(_ textFieldString: String?) -> String? {
        
        guard let str = textFieldString else {
            return nil
        }
        
        let endString = str as NSString
        let range = endString.range(of: separator)
        
        // Check is decimal separator at start or end
        if range.location == 0 {
            
            // Decimal separator at start, fill up 0
            return "0\(endString)"
            
        } else if range.location == endString.length - 1 {
            
            // Decimal separator at end, remove the separator
            return endString.substring(to: endString.length - 1)
        }
        
        return endString as String
    }
}

// MARK:- UITextFieldDelegate
extension KSNumericTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let result = numericTextFieldDelegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: string), result == false {
            
            // Do not change characters in range when user implemented delegate & return false as result
            return false
            
        } else {
            
            // Validate input string when user type / cut & paste
            
            // Remove leading & trailing white space
            let enteredText = string.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: enteredText)
            
            // Set newText to text -> text set observer will check is newText format valid
            let isNewTextValid = setText(newText)
            if  isNewTextValid {
                
                // newText have valid format, thus set cursor to correct position
                let cursorPosition = range.location
                if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition + enteredText.count) {
                    
                    textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                }
            }
            
            return false
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        text = processStringAfterEndEditing(textField.text)
        
        numericTextFieldDelegate?.textFieldDidEndEditing?(self)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        // Handle clear button tapped
        if let result = numericTextFieldDelegate?.textFieldShouldClear?(self), result == false {
            
            // Do not clear text field when user implemented delegate & return false as result
            return false
        } else {
            
            text = ""
            return true
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if let result = numericTextFieldDelegate?.textFieldShouldBeginEditing?(self) {
            return result
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        numericTextFieldDelegate?.textFieldDidBeginEditing?(self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if let result = numericTextFieldDelegate?.textFieldShouldEndEditing?(self) {
            return result
        }
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let result = numericTextFieldDelegate?.textFieldShouldReturn?(self) {
            return result
        }
        
        return true
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        text = processStringAfterEndEditing(textField.text)
        
        numericTextFieldDelegate?.textFieldDidEndEditing?(self, reason: reason)
    }
}
