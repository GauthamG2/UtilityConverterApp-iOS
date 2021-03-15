//
//  UIColor+Color.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-03-02.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIColor {
    
    //static let purple = UIColor(netHex: 0xD8213A)
    
    static let homeCellBorder = UIColor(red:0.75, green:0.92, blue:1, alpha:1)
    static let fundingSummaryBorderColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1)
    
    
    static let maroon = UIColor(red:0.80, green:0.08, blue:0.13, alpha:1.0)
    static let light = UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.0)
    static let themeRed = UIColor(red:0.8, green:0.08, blue:0.13, alpha:1)
    static let lightGray = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0)
    static let darkGary = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1)
    
    static let First     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let Second    = #colorLiteral(red: 0.02745098039, green: 0.3960784314, blue: 0.5215686275, alpha: 1)
    
    
    struct GradientColor {
   
        
        static let HomeView = [
            UIColor.white,
            UIColor(red: 0.43, green: 0.84, blue: 0.98, alpha: 1.00),
            UIColor(red: 0.16, green: 0.50, blue: 0.73, alpha: 1.00)
            
        ]
        
        static let HomeCellView = [
            UIColor(red:0.95, green:0.98, blue:1, alpha:1),
            UIColor.white
        ]

        
        static let ButtonGradient = [
            UIColor.First,
            UIColor.Second,
        ]
    }
}
