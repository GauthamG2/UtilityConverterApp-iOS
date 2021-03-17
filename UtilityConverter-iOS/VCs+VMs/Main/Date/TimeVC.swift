//
//  DateVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-03-17.
//

import UIKit

let TIME_USER_DEFAULTS_KEY = "time"
private let TIME_USER_DEFAULTS_MAX_COUNT = 5

class TimeVC: UIViewController, CustomKeyBoardDelegate {

    

    // MARK: - Outlets
    
    @IBOutlet weak var yearTF                    : UITextField!
    @IBOutlet weak var monthTF                   : UITextField!
    @IBOutlet weak var dayTF                     : UITextField!
    @IBOutlet weak var hourTF                    : UITextField!
    @IBOutlet weak var minuteTF                  : UITextField!
    @IBOutlet weak var secondTF                  : UITextField!
    
    @IBOutlet weak var timeScrollView            : UIScrollView!
    @IBOutlet weak var mainStackView             : UIStackView!
    @IBOutlet weak var mainStackViewTopconstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView            : UIView!
    
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

    // MARK: - ConfigUI
    
    func configUI() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backgroundView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        yearTF.setAsNumericKeyboard(delegate: self)
        monthTF.setAsNumericKeyboard(delegate: self)
        dayTF.setAsNumericKeyboard(delegate: self)
        hourTF.setAsNumericKeyboard(delegate: self)
        minuteTF.setAsNumericKeyboard(delegate: self)
        secondTF.setAsNumericKeyboard(delegate: self)
        
        // Add an observer to track keyboard show event
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
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
                
                let initialY = mainStackView.frame.origin.y + activeTextFieldSuperView.frame.origin.y + activeTextField.frame.origin.y
                
                if initialY > targetY {
                    let diff = targetY - initialY
                    let targetOffsetForTopConstraint = mainStackViewTopconstraint.constant + diff
                    self.view.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.mainStackViewTopconstraint.constant = targetOffsetForTopConstraint
                        self.view.layoutIfNeeded()
                    })
                }
                
                var contentInset:UIEdgeInsets = self.timeScrollView.contentInset
                contentInset.bottom = keyboard.size.height
                timeScrollView.contentInset = contentInset
            }
        }
    }
    
    // MARK: - Hide keyboard function, This function will be called by the tap gesture outside the text field
    
    @objc func keyboardWillHide() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.mainStackViewTopconstraint.constant = self.outerStackViewTopConstraintDefaultHeight
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
        var unit: TimeUnit?
        
        if textField.tag == 1 {
            unit = TimeUnit.year
        } else if textField.tag == 2 {
            unit = TimeUnit.month
        } else if textField.tag == 3 {
            unit = TimeUnit.day
        } else if textField.tag == 4 {
            unit = TimeUnit.hour
        } else if textField.tag == 5 {
            unit = TimeUnit.minute
        } else if textField.tag == 6 {
            unit = TimeUnit.second
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
        if !(yearTF.text?.isEmpty)! && !(monthTF.text?.isEmpty)! &&
            !(dayTF.text?.isEmpty)! && !(hourTF.text?.isEmpty)! &&
            !(minuteTF.text?.isEmpty)! && !(secondTF.text?.isEmpty)!{
            return false
        }
        return true
    }
    
    // MARK: - Updating textfields
    
    func updateTextFields(textField: UITextField, unit: TimeUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                    let weight = Time(unit: unit, value: value)
                    
                    for _unit in TimeUnit.gteAllUnits {
                        if _unit == unit {
                            continue
                        }
                        let textField = mapUnitToTextField(unit: _unit)
                        let result = weight.convert(unit: _unit)
                        
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
            let conversion = "\(yearTF.text!) year = \(monthTF.text!) month = \(dayTF.text!) day = \(hourTF.text!) hour = \(minuteTF.text!) minutes = \(secondTF.text!) second"
            
            var  arrHistory = UserDefaults.standard.array(forKey: TIME_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arrHistory.count >= TIME_USER_DEFAULTS_MAX_COUNT {
                arrHistory = Array(arrHistory.suffix(TIME_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arrHistory.append(conversion)
            UserDefaults.standard.set(arrHistory, forKey: TIME_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "Time conversion succesfully saved", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "No conversion to save", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Mapping units to textfields
    
    func mapUnitToTextField(unit: TimeUnit) -> UITextField {
        var textField = yearTF
        switch unit {
        case .year:
            textField = yearTF
        case .month:
            textField = monthTF
        case .day:
            textField = dayTF
        case .hour:
            textField = hourTF
        case .minute:
            textField = minuteTF
        case .second:
            textField = secondTF
        }
        return textField!
    }
    
    // MARK: Clearing text fields
    
    func clearTextFields() {
        yearTF.text     = ""
        monthTF.text    = ""
        dayTF.text      = ""
        hourTF.text     = ""
        minuteTF.text   = ""
        secondTF.text   = ""
    }
    
    // MARK:  Delegates of CustomKeyPad, This function is a part of the CustomNumericKeyboardDelegate interface
    
    func numericKeyPressed(key: Int) {
        print("Numeric key \(key) pressed!")
    }
    
    func backspacePressed() {
        print("Backspace pressed!")
    }
    
    func symbolPressed(symbol: String) {
        print("Symbol \(symbol) pressed!")
    }
    
    func retractKeyPressed() {
        keyboardWillHide()
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
