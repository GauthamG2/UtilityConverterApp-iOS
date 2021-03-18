//
//  History.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-03-10.
//

import UIKit

class History {
    
    let type      : String
    let icon      : UIImage
    let conversion: String
    
    init(type: String, icon: UIImage, conversion: String) {
        self.type = type
        self.icon = icon
        self.conversion = conversion
    }
    
    func getHistoryType() -> String {
        return type
    }
    
    func getHistoryIcon() -> UIImage {
        return icon
    }
    
    func getHistoryConversion() -> String {
        return conversion
    }
}
