//
//  UITableView+TableView.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-03-10.
//

import Foundation
import UIKit

extension UITableView {
    
    // This function sets an empty message on the table view.
    func setEmptyMessage(_ message: String,_ messageColour: UIColor) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = messageColour
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "OpenSans-Bold", size: 18)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    // This function removes the empty message from the table view.
    
    func restore() {
        self.backgroundView = nil
    }
}
