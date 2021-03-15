//
//  VolumeLiquidVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-19.
//

import UIKit

let VOLUMELIQUID_USER_DEFAULTS_KEY = "volumeliquid"
private let VOLUMELIQUID_USER_DEFAULTS_MAX_COUNT = 5

class VolumeLiquidVC: UIViewController, CustomKeyBoardDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var litreTF                   : UITextField!
    @IBOutlet weak var milliLitreTF              : UITextField!
    @IBOutlet weak var gallonTF                  : UITextField!
    @IBOutlet weak var pintTF                    : UITextField!
    @IBOutlet weak var fluidOunceTF              : UITextField!
    
    @IBOutlet weak var volumeScrollView          : UIScrollView!
    @IBOutlet weak var backgroundView            : UIView!
    @IBOutlet weak var mainStackView             : UIStackView!
    @IBOutlet weak var mainStackViewTopconstraint: NSLayoutConstraint!
    
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
    
    // MARK: - ConfigUI
    
    func configUI() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backgroundView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        litreTF.setAsNumericKeyboard(delegate: self)
        milliLitreTF.setAsNumericKeyboard(delegate: self)
        gallonTF.setAsNumericKeyboard(delegate: self)
        pintTF.setAsNumericKeyboard(delegate: self)
        fluidOunceTF.setAsNumericKeyboard(delegate: self)
        
        // Add an observer to track keyboard show event
        // ad an observer to track keyboard show event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
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
                    let targetOffsetForTopConstraint = mainStackViewTopconstraint.constant + diff
                    self.view.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.mainStackViewTopconstraint.constant = targetOffsetForTopConstraint
                        self.view.layoutIfNeeded()
                    })
                }
                
                var contentInset:UIEdgeInsets = self.volumeScrollView.contentInset
                contentInset.bottom = keyboard.size.height
                volumeScrollView.contentInset = contentInset
            }
        }
    }
    
    // MARK: - Hide keyboard function
    // This function will be called by the tap gesture outside the text field
    
    @objc func keyboardWillHide() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.mainStackViewTopconstraint.constant = self.outerStackViewTopConstraintDefaultHeight
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
        var unit: VolumeUnit?
        
        if textField.tag == 1 {
            unit = VolumeUnit.litre
        } else if textField.tag == 2 {
            unit = VolumeUnit.millilitre
        } else if textField.tag == 3 {
            unit = VolumeUnit.UKgallon
        } else if textField.tag == 4 {
            unit = VolumeUnit.UKpint
        } else if textField.tag == 5 {
            unit = VolumeUnit.fluidOunce
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
        if !(litreTF.text?.isEmpty)! && !(milliLitreTF.text?.isEmpty)! &&
            !(gallonTF.text?.isEmpty)! && !(pintTF.text?.isEmpty)! &&
            !(fluidOunceTF.text?.isEmpty)!{
            return false
        }
        return true
    }
    
    func updateTextFields(textField: UITextField, unit: VolumeUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                    let weight = Volume(unit: unit, value: value)
                    
                    for _unit in VolumeUnit.getAllUnits {
                        if _unit == unit {
                            continue
                        }
                        let textField = mapUnitToTextField(unit: _unit)
                        let result = weight.convert(unit: _unit)
                        
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
            let conversion = "\(litreTF.text!) l = \(milliLitreTF.text!) ml = \(gallonTF.text!) gal = \(pintTF.text!) pt = \(fluidOunceTF.text!) fl oz"
            
            var  arrHistory = UserDefaults.standard.array(forKey: VOLUMELIQUID_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arrHistory.count >= VOLUMELIQUID_USER_DEFAULTS_MAX_COUNT {
                arrHistory = Array(arrHistory.suffix(VOLUMELIQUID_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arrHistory.append(conversion)
            UserDefaults.standard.set(arrHistory, forKey: VOLUMELIQUID_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "Volume conversion succesfully saved", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "No conversion to save", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func mapUnitToTextField(unit: VolumeUnit) -> UITextField {
        var textField = litreTF
        switch unit {
        case .litre:
            textField = litreTF
        case .millilitre:
            textField = milliLitreTF
        case .UKgallon:
            textField = gallonTF
        case .UKpint:
            textField = pintTF
        case .fluidOunce:
            textField = fluidOunceTF
        }
        return textField!
    }
    
    func clearTextFields() {
        litreTF.text        = ""
        milliLitreTF.text   = ""
        gallonTF.text       = ""
        pintTF.text         = ""
        fluidOunceTF.text   = ""
    }
    
    // This function is a part of the CustomNumericKeyboardDelegate interface
    func retractKeyPressed() {
        keyboardWillHide()
    }
    
    func numericKeyPressed(key: Int) {
        print("Numeric key \(key) pressed!")
    }
    
    
    /// and will be triggered when the backspace button is pressed on the custom keyboard.
    func backspacePressed() {
        print("Backspace pressed!")
    }
    
    
    /// and will be triggered when the symobol buttons are pressed on the custom keyboard.
    func symbolPressed(symbol: String) {
        print("Symbol \(symbol) pressed!")
    }
}
