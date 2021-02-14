//
//  HistoryTVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-14.
//

import UIKit

class HistoryTVC: UITableViewCell {

    // MAARK: - Outlets
    
    @IBOutlet weak var viewBackground   : UIView!
    @IBOutlet weak var iconImageView    : UIImageView!
    @IBOutlet weak var lblCobersion     : UILabel!
    
    // MARK: - LifeCycle
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
