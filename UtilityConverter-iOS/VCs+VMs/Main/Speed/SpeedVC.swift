//
//  SpeedVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-19.
//

import UIKit

let SPEED_USER_DEFAULTS_KEY = "speed"
private let SPEED_USER_DEFAULTS_MAX_COUNT = 5

class SpeedVC: UIViewController, CustomKeyBoardDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var msTF                      : UITextField!
    @IBOutlet weak var kmhTF                     : UITextField!
    @IBOutlet weak var mhTF                      : UITextField!
    @IBOutlet weak var nmhTF                     : UITextField!
    
    @IBOutlet weak var speedScrollView           : UIScrollView!
    @IBOutlet weak var backgroundView            : UIView!
    @IBOutlet weak var mainStackView             : UIStackView!
    @IBOutlet weak var mainStackViewtopConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var activeTextField = UITextField()
    var outerStackViewTopConstraintDefaultHeight: CGFloat = 20
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide)))
        
        if isTextFieldsEmpty() {
            self.navigationItem.rightBarButtonItem!.isEnabled = false;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        msTF.setAsNumericKeyboard(delegate: self)
        kmhTF.setAsNumericKeyboard(delegate: self)
        mhTF.setAsNumericKeyboard(delegate: self)
        nmhTF.setAsNumericKeyboard(delegate: self)
        
        // Add an observer to track keyboard show event
        // ad an observer to track keyboard show event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backgroundView.layer.cornerRadius = 10
    }
    
    // MARK: Show keyboard function
    // This function will recognize the first responder and adjust the textfield accordingly considering the keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let firstResponder = self.findFirstResponder(inView: self.view)
        
        if firstResponder != nil {
            activeTextField = firstResponder as! UITextField;
            
            let activeTextFieldSuperView = activeTextField.superview!
            
            if let info = notification.userInfo {
                let keyboard:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
                
                let targetY = view.frame.size.height - keyboard.height - 15 - activeTextField.frame.size.height
                
                let initialY = mainStackView.frame.origin.y + activeTextFieldSuperView.frame.origin.y + activeTextField.frame.origin.y
                
                if initialY > targetY {
                    let diff = targetY - initialY
                    let targetOffsetForTopConstraint = mainStackViewtopConstraint.constant + diff
                    self.view.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.mainStackViewtopConstraint.constant = targetOffsetForTopConstraint
                        self.view.layoutIfNeeded()
                    })
                }
                
                var contentInset:UIEdgeInsets = self.speedScrollView.contentInset
                contentInset.bottom = keyboard.size.height
                speedScrollView.contentInset = contentInset
            }
        }
    }
    
    // MARK: - Hide keyboard function
    // This function will be called by the tap gesture outside the text field
    
    @objc func keyboardWillHide() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.mainStackViewtopConstraint.constant = self.outerStackViewTopConstraintDefaultHeight
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: Find the first responder
    // This fucntion will find the first responder in the UIView, Return a UIView or subview
    
    func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }
            
            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        
        return nil
    }
    @IBAction func handleTextFieldEdit(_ textField: UITextField) {
        var unit: SpeedUnit?
        
        if textField.tag == 1 {
            unit = SpeedUnit.ms
        } else if textField.tag == 2 {
            unit = SpeedUnit.kmh
        } else if textField.tag == 3 {
            unit = SpeedUnit.mih
        } else if textField.tag == 4 {
            unit = SpeedUnit.kn
        }
        
        if unit != nil {
            updateTextFields(textField: textField, unit: unit!)
        }
        
        if isTextFieldsEmpty() {
            self.navigationItem.rightBarButtonItem!.isEnabled = false;
        } else {
            self.navigationItem.rightBarButtonItem!.isEnabled = true;
        }
        
    }
    
    func isTextFieldsEmpty() -> Bool {
        if !(msTF.text?.isEmpty)! && !(kmhTF.text?.isEmpty)! &&
            !(mhTF.text?.isEmpty)! &&
            !(nmhTF.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    func updateTextFields(textField: UITextField, unit: SpeedUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                    let temperature = Speed(value: value, unit: unit)
                    
                    for _unit in SpeedUnit.getAllUnits {
                        if _unit == unit {
                            continue
                        }
                        let textField = mapUnitToTextField(unit: _unit)
                        let result = temperature.convert(unit: _unit)
                        
                        //rounding off to 4 decimal places
                        let roundedResult = Double(round(10000 * result) / 10000)
                        
                        textField.text = String(roundedResult)
                    }
                }
            }
        }
    }
    @IBAction func handleSaveButtonPress(_ sender: UIBarButtonItem) {
        if !isTextFieldsEmpty() {
            let conversion = "\(msTF.text!) m/s = \(kmhTF.text!) km/h = \(mhTF.text!) m/h = \(nmhTF.text!) nm/h"
            
            var  arrHistory = UserDefaults.standard.array(forKey: SPEED_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arrHistory.count >= SPEED_USER_DEFAULTS_MAX_COUNT {
                arrHistory = Array(arrHistory.suffix(SPEED_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arrHistory.append(conversion)
            UserDefaults.standard.set(arrHistory, forKey: SPEED_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "Speed conversion succesfully saved", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "No conversion to save", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mapUnitToTextField(unit: SpeedUnit) -> UITextField {
        var textField = msTF
        switch unit {
        case .ms:
            textField = msTF
        case .kmh:
            textField = kmhTF
        case .mih:
            textField = mhTF
        case .kn:
            textField = nmhTF
        }
        return textField!
    }
    
    func clearTextFields() {
        msTF.text   = ""
        kmhTF.text  = ""
        mhTF.text   = ""
        nmhTF.text  = ""
    }
    
    func retractKeyPressed() {
        keyboardWillHide()
    }
    
    func numericKeyPressed(key: Int) {
        print("Numeric key \(key) pressed!")
    }
    
    /// This function is a part of the CustomNumericKeyboardDelegate interface
    /// and will be triggered when the backspace button is pressed on the custom keyboard.
    func backspacePressed() {
        print("Backspace pressed!")
    }
    
    /// This function is a part of the CustomNumericKeyboardDelegate interface
    /// and will be triggered when the symobol buttons are pressed on the custom keyboard.
    func symbolPressed(symbol: String) {
        print("Symbol \(symbol) pressed!")
    }
}
