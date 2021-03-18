//
//  TemperatureVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-19.
//

import UIKit

let TEMPERATURE_USER_DEFAULTS_KEY = "temperature"
private let TEMPERATURE_USER_DEFAULTS_MAX_COUNT = 5

class TemperatureVC: UIViewController, CustomKeyBoardDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var celsiusTF                 : UITextField!
    @IBOutlet weak var fahrenheitTF              : UITextField!
    @IBOutlet weak var kelvinTF                  : UITextField!
    
    @IBOutlet weak var temperatureScrollview     : UIScrollView!
    @IBOutlet weak var viewBackground            : UIView!
    @IBOutlet weak var mainStackview             : UIStackView!
    @IBOutlet weak var mainStackviewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var activeTextField = UITextField()
    var outerStackViewTopConstraintDefaultHeight: CGFloat = 20
    
    var precisionValue: Double = 100.0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide)))
        
        if isTextFieldsEmpty() {
            self.navigationItem.rightBarButtonItem!.isEnabled = false;
        }
        
        setDecimalValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        celsiusTF.setAsNumericKeyboard(delegate: self)
        fahrenheitTF.setAsNumericKeyboard(delegate: self)
        kelvinTF.setAsNumericKeyboard(delegate: self)
        
        // Observer to track keyboard show event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableMinusButton"), object: nil)
    }
    // MARK: - ConfigUI
    
    func configUI() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        viewBackground.layer.borderWidth  = 2
        viewBackground.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        viewBackground.layer.cornerRadius = 10
    }
    
    // MARK: - Show keyboard function , This function will recognize the first responder and adjust the textfield accordingly considering the keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let firstResponder = self.findFirstResponder(inView: self.view)
        
        if firstResponder != nil {
            activeTextField = firstResponder as! UITextField;
            
            let activeTextFieldSuperView = activeTextField.superview!
            
            if let info = notification.userInfo {
                let keyboard:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
                
                let targetY = view.frame.size.height - keyboard.height - 15 - activeTextField.frame.size.height
                
                let initialY = mainStackview.frame.origin.y + activeTextFieldSuperView.frame.origin.y + activeTextField.frame.origin.y
                
                if initialY > targetY {
                    let diff = targetY - initialY
                    let targetOffsetForTopConstraint = mainStackviewTopConstraint.constant + diff
                    self.view.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.mainStackviewTopConstraint.constant = targetOffsetForTopConstraint
                        self.view.layoutIfNeeded()
                    })
                }
                
                var contentInset:UIEdgeInsets = self.temperatureScrollview.contentInset
                contentInset.bottom = keyboard.size.height
                temperatureScrollview.contentInset = contentInset
            }
        }
    }
    
    // MARK: - Hide keyboard function, This function will be called by the tap gesture outside the text field
    
    @objc func keyboardWillHide() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.mainStackviewTopConstraint.constant = self.outerStackViewTopConstraintDefaultHeight
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Find the first responder, This fucntion will find the first responder in the UIView, Return a UIView or subview
    
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
    
    // MARK: - Handle the textfield editing
    
    @IBAction func handleTextFieldChange(_ textField: UITextField) {
        var unit: TemperatureUnit?
        
        if textField.tag == 1 {
            unit = TemperatureUnit.celsius
        } else if textField.tag == 2 {
            unit = TemperatureUnit.fahrenheit
        } else if textField.tag == 3 {
            unit = TemperatureUnit.kelvin
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
    
    // MARK: Checking if the textfield is empty
    
    func isTextFieldsEmpty() -> Bool {
        if !(celsiusTF.text?.isEmpty)! && !(fahrenheitTF.text?.isEmpty)! &&
            !(kelvinTF.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    // MARK: - Updating textfields
    
    func updateTextFields(textField: UITextField, unit: TemperatureUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                    let temperature = Temperature(value: value, unit: unit)
                    
                    for _unit in TemperatureUnit.getAllUnits {
                        if _unit == unit {
                            continue
                        }
                        let textField = mapUnitToTextField(unit: _unit)
                        let result = temperature.convert(unit: _unit)
                        
                        // Rounding off to required precision value
                        
                        let roundedResult = Double(round(precisionValue * result) / precisionValue)
                        textField.text = String(roundedResult)
                    }
                }
            }
        }
    }
    
    // MARK: - Saving History, This function will save the history to user defaults and check for the no of elements saved
    
    @IBAction func handleSaveButtonPress(_ sender: UIBarButtonItem) {
        
        if !isTextFieldsEmpty() {
            let conversion = "\(celsiusTF.text!) °C = \(fahrenheitTF.text!) °F = \(kelvinTF.text!) K"
            
            var  arrHistory = UserDefaults.standard.array(forKey: TEMPERATURE_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arrHistory.count >= TEMPERATURE_USER_DEFAULTS_MAX_COUNT {
                arrHistory = Array(arrHistory.suffix(TEMPERATURE_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arrHistory.append(conversion)
            UserDefaults.standard.set(arrHistory, forKey: TEMPERATURE_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "Temperature conversion succesfully saved", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "No conversion to save", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Mapping units to textfields
    
    func mapUnitToTextField(unit: TemperatureUnit) -> UITextField {
        var textField = celsiusTF
        switch unit {
        case .celsius:
            textField = celsiusTF
        case .fahrenheit:
            textField = fahrenheitTF
        case .kelvin:
            textField = kelvinTF
        }
        return textField!
    }
    
    // MARK: Clearing text fields
    
    func clearTextFields() {
        celsiusTF.text    = ""
        fahrenheitTF.text = ""
        kelvinTF.text     = ""
    }
    
    // MARK:  Delegates of CustomKeyPad, This function is a part of the CustomNumericKeyboardDelegate interface
    
    func retractKeyPressed() {
        keyboardWillHide()
    }
    
    func numericKeyPressed(key: Int) {
        print("Numeric key \(key) pressed!")
    }
    
    func backspacePressed() {
        print("Backspace pressed!")
    }
    
    func symbolPressed(symbol: String) {
        print("Symbol \(symbol) pressed!")
    }
    
    // MARK:  Check for precision value from settings screen
    
    func setDecimalValue() {
        
        let precision =  UserDefaults.standard.object(forKey: "DecimalKey") as? String ?? ""
        
        switch precision {
        case "2":
            precisionValue = 100
        case "3":
            precisionValue = 1000
        case "4":
            precisionValue = 10000
        default:
            precisionValue = 100
        }
    }
}

