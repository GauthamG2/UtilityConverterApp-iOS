//
//  LengthVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-19.
//

import UIKit


let LENGTH_USER_DEFAULTS_KEY = "length"
private let LENGTH_USER_DEFAULTS_MAX_COUNT = 5

class LengthVC: UIViewController, CustomKeyBoardDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var meterTF                   : UITextField!
    @IBOutlet weak var kilometerTF               : UITextField!
    @IBOutlet weak var mileTF                    : UITextField!
    @IBOutlet weak var centimeterTF              : UITextField!
    @IBOutlet weak var millimeterTF              : UITextField!
    @IBOutlet weak var yardTF                    : UITextField!
    @IBOutlet weak var inchTF                    : UITextField!
    
    @IBOutlet weak var lengthScrollView          : UIScrollView!
    @IBOutlet weak var mainStackView             : UIStackView!
    @IBOutlet weak var backgroundView            : UIView!
    @IBOutlet weak var mainStackViewTopConstraint: NSLayoutConstraint!
    
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
        
        meterTF.setAsNumericKeyboard(delegate: self)
        kilometerTF.setAsNumericKeyboard(delegate: self)
        mileTF.setAsNumericKeyboard(delegate: self)
        centimeterTF.setAsNumericKeyboard(delegate: self)
        millimeterTF.setAsNumericKeyboard(delegate: self)
        yardTF.setAsNumericKeyboard(delegate: self)
        inchTF.setAsNumericKeyboard(delegate: self)
        
        // Add an observer to track keyboard show event
        // ad an observer to track keyboard show event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableMinusButton"), object: nil)
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        backgroundView.layer.borderWidth    = 1
        backgroundView.layer.borderColor    = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backgroundView.layer.cornerRadius   = 10
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
                    let targetOffsetForTopConstraint = mainStackViewTopConstraint.constant + diff
                    self.view.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.mainStackViewTopConstraint.constant = targetOffsetForTopConstraint
                        self.view.layoutIfNeeded()
                    })
                }
                
                var contentInset:UIEdgeInsets = self.lengthScrollView.contentInset
                contentInset.bottom = keyboard.size.height
                lengthScrollView.contentInset = contentInset
            }
        }
    }
    
    // MARK: - Hide keyboard function
    // This function will be called by the tap gesture outside the text field
    
    @objc func keyboardWillHide() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.mainStackViewTopConstraint.constant = self.outerStackViewTopConstraintDefaultHeight
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
        var unit: LengthUnit?
        
        if textField.tag == 1 {
            unit = LengthUnit.metre
        } else if textField.tag == 2 {
            unit = LengthUnit.kiloMetre
        } else if textField.tag == 3 {
            unit = LengthUnit.mile
        } else if textField.tag == 4 {
            unit = LengthUnit.centiMetre
        } else if textField.tag == 5 {
            unit = LengthUnit.milliMetre
        } else if textField.tag == 6 {
            unit = LengthUnit.yard
        } else if textField.tag == 7 {
            unit = LengthUnit.inch
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
        if !(meterTF.text?.isEmpty)! && !(kilometerTF.text?.isEmpty)! &&
            !(mileTF.text?.isEmpty)! &&
            !(centimeterTF.text?.isEmpty)! &&
            !(millimeterTF.text?.isEmpty)! &&
            !(yardTF.text?.isEmpty)! &&
            !(inchTF.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    func updateTextFields(textField: UITextField, unit: LengthUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                    let temperature = Length(value: value, unit: unit)
                    
                    for _unit in LengthUnit.getAllUnits {
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
            let conversion = "\(meterTF.text!) m = \(kilometerTF.text!) km = \(mileTF.text!) miles = \(centimeterTF.text!) cm = \(millimeterTF.text!) mm = \(yardTF.text!) yard = \(inchTF.text!) inches"
            
            var  arrHistory = UserDefaults.standard.array(forKey: LENGTH_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arrHistory.count >= LENGTH_USER_DEFAULTS_MAX_COUNT{
                arrHistory = Array(arrHistory.suffix(LENGTH_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arrHistory.append(conversion)
            UserDefaults.standard.set(arrHistory, forKey: LENGTH_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "Length conversion succesfully saved", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "No conversion to save", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func mapUnitToTextField(unit: LengthUnit) -> UITextField {
        var textField = meterTF
        switch unit {
        case .metre:
            textField = meterTF
        case .kiloMetre:
            textField = kilometerTF
        case .mile:
            textField = mileTF
        case .centiMetre:
            textField = centimeterTF
        case .milliMetre:
            textField = millimeterTF
        case .yard:
            textField = yardTF
        case .inch:
            textField = inchTF
        }
        return textField!
    }
    
    func clearTextFields() {
        meterTF.text        = ""
        kilometerTF.text    = ""
        mileTF.text         = ""
        centimeterTF.text   = ""
        millimeterTF.text   = ""
        yardTF.text         = ""
        inchTF.text         = ""
        
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
