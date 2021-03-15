//
//  Extensions.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-03-02.
//

import Foundation
import UIKit

extension UIView {
    func addLayerEffects(with borderColor: UIColor? = nil, borderWidth: CGFloat = 0.0, cornerRadius: CGFloat = 0.0) {
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addCornerRadius(radius: CGFloat) {
         self.layer.cornerRadius = radius
     }
    
    func addShadow(offSet: CGFloat = 2.0, color: UIColor = .lightGray) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: offSet, height: offSet)
        self.layer.shadowOpacity = 1
        self.layer.shouldRasterize = false
        self.layer.masksToBounds = false
    }
    
    func applyGradient(isTopBottom: Bool, colorArray: [UIColor]) {
        if let sublayers = layer.sublayers {
            let _ = sublayers.filter({ $0 is CAGradientLayer }).map({ $0.removeFromSuperlayer() })
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isTopBottom {
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //leftRight
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = self.bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
 
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor, colorFour: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor, colorThree.cgColor, colorFour.cgColor ]
        //gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
