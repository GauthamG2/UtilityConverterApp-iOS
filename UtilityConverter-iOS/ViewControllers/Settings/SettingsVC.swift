//
//  SettingsVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-19.
//

import UIKit
import RxCocoa
import RxSwift


class SettingsVC: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var settingsBackgroundView: UIView!
    
    @IBOutlet weak var btnTwoDecimal         : UIButton!
    @IBOutlet weak var btnThreeDecimal       : UIButton!
    @IBOutlet weak var btnFourDecimal        : UIButton!
    
    @IBOutlet weak var lblSelectedValue      : UILabel!
    @IBOutlet var firstBackgroundView: UIView!
    
    // MARK: - Variables
    
    private let bag = DisposeBag()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        addObservers()
        
        
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        firstBackgroundView.applyGradient(isTopBottom: true, colorArray: UIColor.GradientColor.HomeView)
        
        btnTwoDecimal.layer.cornerRadius   = 10
        btnThreeDecimal.layer.cornerRadius = 10
        btnFourDecimal.layer.cornerRadius  = 10
        
        btnTwoDecimal.layer.borderWidth    = 1
        btnThreeDecimal.layer.borderWidth  = 1
        btnFourDecimal.layer.borderWidth   = 1
        
        btnTwoDecimal.layer.borderColor    = #colorLiteral(red: 0.007843137255, green: 0.08235294118, blue: 0.1568627451, alpha: 1)
        btnThreeDecimal.layer.borderColor  = #colorLiteral(red: 0.007843137255, green: 0.08235294118, blue: 0.1568627451, alpha: 1)
        btnFourDecimal.layer.borderColor   = #colorLiteral(red: 0.007843137255, green: 0.08235294118, blue: 0.1568627451, alpha: 1)
    }
    
    // MARK: - Observers
    
    func addObservers() {
        
        btnTwoDecimal.rx.tap
            .subscribe(){ [weak self] event in
                self?.didTapOnBtnTwoDecimal()
        }
        .disposed(by: bag)
        
        btnThreeDecimal.rx.tap
            .subscribe(){ [weak self] event in
                self?.didTapOnBtnThreeDecimal()
        }
        .disposed(by: bag)
        
        btnFourDecimal.rx.tap
            .subscribe(){ [weak self] event in
                self?.didTapOnBtnFourDecimal()
        }
        .disposed(by: bag)
    }
    
    // MARK: - Outlet Actions
    
    func didTapOnBtnTwoDecimal() {
        let defaults = UserDefaults.standard
        defaults.set("2", forKey: "DecimalKey")
        
        lblSelectedValue.text = "Selected Value: 0.00"
    }
    
    func didTapOnBtnThreeDecimal() {
        let defaults = UserDefaults.standard
        defaults.set("3", forKey: "DecimalKey")
        
        lblSelectedValue.text = "Selected Value: 0.000"
    }
    
    func didTapOnBtnFourDecimal() {
        let defaults = UserDefaults.standard
        defaults.set("4", forKey: "DecimalKey")
        
        lblSelectedValue.text = "Selected Value: 0.0000"
    }
    

}
