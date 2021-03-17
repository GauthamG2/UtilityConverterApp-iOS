//
//  HistoryVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-14.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var firstBackgroundView   : UIView!
    @IBOutlet weak var backgroundView   : UIView!
    @IBOutlet weak var btnSegmentControl: UISegmentedControl!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var historyTableView : UITableView! {
        didSet {
            historyTableView.dataSource = self
            historyTableView.delegate   = self
        }
    }
    
    // MARK: - Variables
    
    var historyData    = [History]()
    var conversionType = WEIGHT_USER_DEFAULTS_KEY
    var icon: UIImage  = UIImage(named: "weight")!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lblTitle.text = "Weight History"
        
        // Generate and display the history data of the first segment
        generateConversionHistory(type: conversionType, icon: icon)
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }
        
        // Check the visibility of the delete button
       // historyClearButtonVisibility()
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        firstBackgroundView.applyGradient(isTopBottom: true, colorArray: UIColor.GradientColor.HomeView)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    @IBAction func handleClearHistoryAction(_ sender: Any) {
        if historyData.count > 0 {
            UserDefaults.standard.set([], forKey: conversionType)
            
            let alert = UIAlertController(title: "Success", message: "The conversions are successfully deleted!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            // Refresh history data and reload the tableview
            generateConversionHistory(type: conversionType, icon: icon)
            DispatchQueue.main.async{ self.historyTableView.reloadData() }
            historyClearButtonVisibility()
        }
    }
    
    func historyClearButtonVisibility() {
        if historyData.count > 0 {
            self.navigationItem.rightBarButtonItem!.isEnabled = true;
        } else {
            self.navigationItem.rightBarButtonItem!.isEnabled = false;
        }
    }
    
    func generateConversionHistory(type: String, icon: UIImage) {
        historyData = []
        let historyList = UserDefaults.standard.value(forKey: conversionType) as? [String]
        
        if historyList?.count ?? 0 > 0 {
            for conversion in historyList! {
                let history = History(type: type, icon: icon, conversion: conversion)
                historyData += [history]
            }
        }
    }
    
    @IBAction func handleSegementedcontrolChange(_ sender: UISegmentedControl) {
        switch btnSegmentControl.selectedSegmentIndex {
        
        case 0:
            conversionType = WEIGHT_USER_DEFAULTS_KEY
            icon = UIImage(named: "weight-128")!
            lblTitle.text = "Weight History"
        case 1:
            conversionType = TEMPERATURE_USER_DEFAULTS_KEY
            icon = UIImage(named: "temperature-128")!
            lblTitle.text = "Temperature History"
        case 2:
            conversionType = LENGTH_USER_DEFAULTS_KEY
            icon = UIImage(named: "length-128")!
            lblTitle.text = "Length History"
        case 3:
            conversionType = SPEED_USER_DEFAULTS_KEY
            icon = UIImage(named: "speed-128")!
            lblTitle.text = "Speed History"
        case 4:
            conversionType = VOLUMELIQUID_USER_DEFAULTS_KEY
            icon = UIImage(named: "volume-128")!
            lblTitle.text = "Volume History"
        case 5:
            conversionType = TIME_USER_DEFAULTS_KEY
            icon = UIImage(named: "date-128")!
            lblTitle.text = "Time History"
        default:
            break
        }
        
        generateConversionHistory(type: conversionType, icon: icon)
        
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }
        
        historyClearButtonVisibility()
    }
    

}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyData.count == 0 {
            self.historyTableView.setEmptyMessage("No conversions saved", #colorLiteral(red: 0.007843137255, green: 0.08235294118, blue: 0.1568627451, alpha: 1))
        } else {
            self.historyTableView.restore()
        }
        return historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryTVC = historyTableView.dequeueReusableCell(withIdentifier: "HistoryTVC", for: indexPath) as! HistoryTVC
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        cell.lblConversion.text = historyData[indexPath.row].getHistoryConversion()
        cell.iconImageView.image = historyData[indexPath.row].getHistoryIcon()
        
        cell.viewBackground.layer.borderWidth     = 2
        cell.viewBackground.layer.borderColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.viewBackground.layer.cornerRadius    = 10
        cell.viewBackground.layer.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.08235294118, blue: 0.1568627451, alpha: 1)
        
       
        
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
