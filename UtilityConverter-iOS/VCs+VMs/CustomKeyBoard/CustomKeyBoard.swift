//
//  CustomKeyBoard.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-20.
//

import UIKit

// Seting keyboard height

let customKeyBoardHeight = 274

// Set custom keypad button colors

private let defaultKeyColour = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
private let pressedKeyColour = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)

@objc protocol CustomKeyBoardDelegate {
    func numericKeyPressed(key: Int)
    func backspacePressed()
    func symbolPressed(symbol: String)
    func retractKeyPressed()
}

class CustomKeyBoard: UIView {

    // MARK: - Outlets
    
    @IBOutlet weak var btn0             : UIButton!
    @IBOutlet weak var btn1             : UIButton!
    @IBOutlet weak var btn2             : UIButton!
    @IBOutlet weak var btn3             : UIButton!
    @IBOutlet weak var btn4             : UIButton!
    @IBOutlet weak var btn5             : UIButton!
    @IBOutlet weak var btn6             : UIButton!
    @IBOutlet weak var btn7             : UIButton!
    @IBOutlet weak var btn8             : UIButton!
    @IBOutlet weak var btn9             : UIButton!
    @IBOutlet weak var btnPeriodKey     : UIButton!
    @IBOutlet weak var btnMinusKey      : UIButton!
    @IBOutlet weak var btnRetractKey    : UIButton!
    @IBOutlet weak var btnBackspaceKey  : UIButton!
    
    // MARK: - Variables
    
    var allButtons: [UIButton] {
        return [btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, btnPeriodKey, btnMinusKey]
    }
    
    weak var delegate: CustomKeyBoardDelegate?
    
    var defaultButtonBgColor   = defaultKeyColour { didSet { updateButtonAppearance() }}
    var pressedButtonBgColor   = pressedKeyColour { didSet { updateButtonAppearance() }}
    var defaultButtonFontColor = UIColor.gray { didSet { updateButtonAppearance() }}
    var pressedButtonFontColor = UIColor.white { didSet { updateButtonAppearance() }}


    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(enableMinusButton(notification:)),
                                               name: NSNotification.Name(rawValue: "enableMinusButton"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeKeyboard()
    }
    
    func initializeKeyboard() {
        let xibFileName = "CustomKeyBoard"
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
        updateButtonAppearance()
        
        // Disables minus button by default
        btnMinusKey.isUserInteractionEnabled = false
    }
    
    // This function changes the appearance of the button according to the state
    fileprivate func updateButtonAppearance() {
        for button in allButtons {
            button.setTitleColor(defaultButtonFontColor, for: .normal)
            button.setTitleColor(pressedButtonFontColor, for: [.selected, .highlighted])
            
            if button.isSelected {
                button.backgroundColor = pressedButtonBgColor
            } else {
                button.backgroundColor = defaultButtonBgColor
            }
        }
    }
    
    // This function can be used to programatically enable the minus button.
    @objc func enableMinusButton(notification: NSNotification) {
        btnMinusKey.isUserInteractionEnabled = true
    }
    
    // This outlet action handles the numeric button pressing
    @IBAction func handleNumericButtonPressing(_ sender: UIButton) {
        self.delegate?.numericKeyPressed(key: sender.tag)
    }
    
    // This outlet action handles the retract button pressing
    @IBAction func handleRetractButtonPressing(_ sender: UIButton) {
        self.delegate?.retractKeyPressed()
    }
    
    // This outlet action handles the backspace button pressing
    @IBAction func handleBackspaceButtonPressing(_ sender: UIButton) {
        self.delegate?.backspacePressed()
    }
    
    // This outlet action handles the symbol button pressing
    @IBAction func handleSymbolButtonPressing(_ sender: UIButton) {
        if let symbol = sender.titleLabel?.text, symbol.count > 0 {
            self.delegate?.symbolPressed(symbol: symbol)
        }
    }
}
