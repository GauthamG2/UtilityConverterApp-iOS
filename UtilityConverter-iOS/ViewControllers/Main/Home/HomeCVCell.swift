//
//  HomeCVCell.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-14.
//

import UIKit

class HomeCVCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var viewBackground   : UIView!
    @IBOutlet weak var iconImage        : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    
    // MARK: - ConfigCell
    
    func configCell(model: Conversions) {
        iconImage.image = model.imgIcon
        lblTitle.text = model.key.rawValue
    }
    
    // MARK: - LayoutSubViews
    
    override func layoutSubviews() {
        viewBackground.layer.cornerRadius    = 10
        viewBackground.layer.borderWidth     = 1
        viewBackground.layer.borderColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        viewBackground.layer.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.08235294118, blue: 0.1568627451, alpha: 1)
    }
}
