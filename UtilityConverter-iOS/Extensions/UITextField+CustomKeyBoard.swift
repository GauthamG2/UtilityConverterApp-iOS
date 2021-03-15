//
//  UITextField+CustomKeyBoard.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-22.
//

import Foundation
import UIKit

private var keyboardDelegate: CustomKeyBoardDelegate? = nil

extension UITextField: CustomKeyBoardDelegate {
    
    func setAsNumericKeyboard(delegate: CustomKeyBoardDelegate?) {
        let numericKeyboard = CustomKeyBoard(frame: CGRect(x: 0, y: 0, width: 0, height: customKeyBoardHeight))
        self.inputView = numericKeyboard
        keyboardDelegate = delegate
        numericKeyboard.delegate = self
    }
    
    func unsetAsNumericKeyboard() {
        if let numericKeyboard = self.inputView as? CustomKeyBoard {
            numericKeyboard.delegate = nil
        }
        self.inputView = nil
        keyboardDelegate = nil
    }
    
    
    internal func numericKeyPressed(key: Int) {
        self.insertText(String(key))
        keyboardDelegate?.numericKeyPressed(key: key)
    }
    
    internal func backspacePressed() {
        self.deleteBackward()
        keyboardDelegate?.backspacePressed()
    }
    
    internal func symbolPressed(symbol: String) {
        self.insertText(String(symbol))
        keyboardDelegate?.symbolPressed(symbol: symbol)
    }
    
    internal func retractKeyPressed() {
        keyboardDelegate?.retractKeyPressed()
    }
    
    
}

