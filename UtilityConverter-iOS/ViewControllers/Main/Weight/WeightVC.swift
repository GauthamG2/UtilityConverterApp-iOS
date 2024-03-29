//
//  WeightVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-19.
//

import UIKit

let WEIGHT_USER_DEFAULTS_KEY = "weight"
private let WEIGHT_USER_DEFAULTS_MAX_COUNT = 5

class WeightVC: UIViewController, CustomKeyBoardDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var kilogramTF                   : UITextField!
    @IBOutlet weak var gramTF                       : UITextField!
    @IBOutlet weak var ounceTF                      : UITextField!
    @IBOutlet weak var poundsTF                     : UITextField!
    @IBOutlet weak var stoneTF                      : UITextField!
    @IBOutlet weak var stonePoundsTF                : UITextField!
    
    @IBOutlet weak var viewBackground               : UIView!
    @IBOutlet weak var weightScrollView             : UIScrollView!
    @IBOutlet weak var mainStackView                : UIStackView!
    @IBOutlet weak var mainStackViewTopConstraint   : NSLayoutConstraint!
    
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
       
        
        kilogramTF.setAsNumericKeyboard(delegate: self)
        gramTF.setAsNumericKeyboard(delegate: self)
        ounceTF.setAsNumericKeyboard(delegate: self)
        poundsTF.setAsNumericKeyboard(delegate: self)
        stoneTF.setAsNumericKeyboard(delegate: self)
        stonePoundsTF.setAsNumericKeyboard(delegate: self)
        
        // Observer to track keyboard show event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        //viewBackground.applyGradient(isTopBottom: true, colorArray: UIColor.GradientColor.HomeView)
        //viewBackground.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.08235294118, blue: 0.1568627451, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        viewBackground.layer.borderWidth = 2
        viewBackground.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        viewBackground.layer.cornerRadius = 10
    }
    
    // MARK: - Show keyboard function , This function will recognize the first responder and adjust the textfield accordingly considering the keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let firstResponder = self.findFirstResponder(inView: self.view)
        
        if firstResponder != nil {
            activeTextField = firstResponder as! UITextField;
            
            var activeTextFieldSuperView = activeTextField.superview!
            
            if activeTextField.tag == 5 || activeTextField.tag == 6 {
                activeTextFieldSuperView = activeTextField.superview!.superview!
            }
            
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
                
                var contentInset:UIEdgeInsets = self.weightScrollView.contentInset
                contentInset.bottom = keyboard.size.height
                weightScrollView.contentInset = contentInset
            }
        }
    }
    
    // MARK: - Hide keyboard function, This function will be called by the tap gesture outside the text field
    
    @objc func keyboardWillHide() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.mainStackViewTopConstraint.constant = self.outerStackViewTopConstraintDefaultHeight
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
    
    @IBAction func handleTextFieldEditing(_ textField: UITextField) {
        var unit: WeightUnit?
        
        if textField.tag == 1 {
            unit = WeightUnit.kilogram
        } else if textField.tag == 2 {
            unit = WeightUnit.gram
        } else if textField.tag == 3 {
            unit = WeightUnit.ounce
        } else if textField.tag == 4 {
            unit = WeightUnit.pound
        } else if textField.tag == 5 {
            unit = WeightUnit.stone
        } else if textField.tag == 6 {
            unit = WeightUnit.stone
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
        if !(kilogramTF.text?.isEmpty)! && !(gramTF.text?.isEmpty)! &&
            !(ounceTF.text?.isEmpty)! && !(poundsTF.text?.isEmpty)! &&
            !(stoneTF.text?.isEmpty)! && !(stonePoundsTF.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    // MARK: - Updating textfields
    
    func updateTextFields(textField: UITextField, unit: WeightUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                    let weight = Weight(value: value, unit: unit)
                    
                    for _unit in WeightUnit.getAllUnits {
                        if _unit == unit {
                            continue
                        }
                        let textField = mapUnitToTextField(unit: _unit)
                        let result = weight.convert(unit: _unit)
                        
                        // Rounding off to required precision value
                        
                        let roundedResult = Double(round(precisionValue * result) / precisionValue)
                        textField.text = String(roundedResult)
                        
                        // Stone pound calculation
                        moderateStonePounds()
                    }
                }
            }
        }
    }
    
    // MARK: - Mapping units to textfields
    
    func mapUnitToTextField(unit: WeightUnit) -> UITextField {
        var textField = kilogramTF
        switch unit {
        case .kilogram:
            textField = kilogramTF
        case .gram:
            textField = gramTF
        case .ounce:
            textField = ounceTF
        case .pound:
            textField = poundsTF
        case .stone:
            textField = stoneTF
        }
        return textField!
    }
    
    // MARK: Clearing text fields
    
    func clearTextFields() {
        kilogramTF.text    = ""
        gramTF.text        = ""
        ounceTF.text       = ""
        poundsTF.text      = ""
        stoneTF.text       = ""
        stonePoundsTF.text = ""
    }
    
    // MARK: - Saving History, This function will save the history to user defaults and check for the no of elements saved
    
    @IBAction func handleSaveButtonClick(_ sender: UIBarButtonItem) {
        if !isTextFieldsEmpty() {
            let conversion = "\(kilogramTF.text!) kg = \(gramTF.text!) g = \(ounceTF.text!) oz = \(poundsTF.text!) lb = \(stoneTF.text!) stones & \(stonePoundsTF.text!) pounds"
            
            var  arrHistory = UserDefaults.standard.array(forKey: WEIGHT_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arrHistory.count >= WEIGHT_USER_DEFAULTS_MAX_COUNT {
                arrHistory = Array(arrHistory.suffix(WEIGHT_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arrHistory.append(conversion)
            UserDefaults.standard.set(arrHistory, forKey: WEIGHT_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "Weight conversion succesfully saved", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "No conversion to save", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Stone pound conversion
    
    func moderateStonePounds() {
        if let textFieldVal = stoneTF.text {
            if let value = Double(textFieldVal as String) {
                let integerPart = Int(value)
                let decimalPart = value.truncatingRemainder(dividingBy: 1)
                let poundValue = decimalPart * 14
                
                stoneTF.text = String(integerPart)
                stonePoundsTF.text = String(Double(round(10000 * poundValue) / 10000))
            }
        }
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

// MARK: - Extensions

extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
