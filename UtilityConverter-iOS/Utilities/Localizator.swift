//
//  Localizator.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-19.
//

import Foundation
import UIKit

public class Localizator {
    fileprivate func NSLocalizedString(_ key: String) -> String {
        return Foundation.NSLocalizedString(key, comment: "")
    }
}

extension String {

    // Alert titles
    static let Alert = NSLocalizedString("Alert", comment: "")
    static let Confirmation = NSLocalizedString("Confirmation", comment: "")
    static let Error = NSLocalizedString("Error", comment: "")
    static let Incomplete = NSLocalizedString("Incomplete", comment: "")
    static let Success = NSLocalizedString("Success", comment: "")
    static let Failed = NSLocalizedString("Failed", comment: "")
    
    // ALERT MESSAGES
    // Local error messages
    static let ErrorCorrupted = NSLocalizedString("Error is corrupted.", comment: "")
    static let MissingData = NSLocalizedString("Missing data in the request.", comment: "")
    static let AnyFieldEmpty = NSLocalizedString("All fields are required.", comment: "")
    static let MissingRequiredFields = NSLocalizedString("Missing some required fields.", comment: "")
    
    // Success messages
    
    // Confirmation messages
    static let LogoutConfirmation = NSLocalizedString("Are you sure you want to logout?", comment: "")
    
    // Action titles
    static let Ok = NSLocalizedString("OK", comment: "")
    static let Cancel = NSLocalizedString("Cancel", comment: "")
    static let Yes = NSLocalizedString("Yes", comment: "")
    static let No = NSLocalizedString("No", comment: "")
    
    // Placeholders
    
    
    // Storyboard identifiers
    
    // ViewControllers
    static let LoginVC = NSLocalizedString("LoginVC", comment: "")
    static let HomeVC = NSLocalizedString("HomeVC", comment: "")
    static let WeightVC = NSLocalizedString("WeightVC", comment: "")
    static let TemperatureVC = NSLocalizedString("TemperatureVC", comment: "")
    static let LengthVC = NSLocalizedString("LengthVC", comment: "")
    static let SpeedVC = NSLocalizedString("SpeedVC", comment: "")
    static let VolumeLiquidVC = NSLocalizedString("VolumeLiquidVC", comment: "")
    static let HistoryVC = NSLocalizedString("HistoryVC", comment: "")
    static let SettingsVC = NSLocalizedString("HistoryVC", comment: "")
    static let TimeVC = NSLocalizedString("TimeVC", comment: "")
    
    
    // Top viewController of the Storyboard
    static let HomeNC = NSLocalizedString("HomeNC", comment: "")
    static let HistoryNC = NSLocalizedString("HomeNC", comment: "")
    static let ConstantNC = NSLocalizedString("HomeNC", comment: "")
    static let SettingsNC = NSLocalizedString("HomeNC", comment: "")
   
    static let MainTBC = NSLocalizedString("MainTBC", comment: "")
}


