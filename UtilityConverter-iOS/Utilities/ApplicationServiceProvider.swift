//
//  ApplicationServiceProvider.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-19.
//

import Foundation
import UIKit

enum Storyboard: String {
    case Main
}

class ApplicationServiceProvider {
    
    static let shared = ApplicationServiceProvider()
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private init() {}
    
    // Direct to Main Root window
    public func directToPath(in sb: Storyboard, for identifier: String, from vc: UIViewController? = nil, window: UIWindow? = nil) {
        let storyboard = UIStoryboard(name: sb.rawValue, bundle: nil)
        let topController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        appDelegate.setAsRoot(_controller: topController) 
    }
    
    // Navigation - Push to view controller
    
    public func pushToViewController(in sb: Storyboard, for identifier: String, from vc: UIViewController, data: Any? = nil) {
        
        let storyboard = UIStoryboard(name: sb.rawValue, bundle: nil)
        let destVc = storyboard.instantiateViewController(withIdentifier: identifier)
        vc.navigationController?.pushViewController(destVc, animated: true)
    }
    
    // Get View Controller
    public func viewController(in sb: Storyboard, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: sb.rawValue, bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: identifier)
        return targetVC
    }
    
}
