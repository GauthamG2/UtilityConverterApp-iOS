//
//  HistoryVM.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-14.
//


import UIKit

class HistoryVM: NSObject {
    
    var arrConversionHistory : [ConversionHistory] = []
    
    func getConversionHistory() {
        
        arrConversionHistory.append(ConversionHistory(imgIcon: UIImage(named: "weight")!, key: .Weight))
        arrConversionHistory.append(ConversionHistory(imgIcon: UIImage(named: "weight")!, key: .Weight))
    }
}

struct ConversionHistory {
    var imgIcon : UIImage
    var key     : ConversionHistoryKey
}

enum ConversionHistoryKey: String {
    case Weight       = "Weight"
    case Temperature  = "Temperature"
    case Length       = "Length"
    case Speed        = "Speed"
    case VolumeLiquid = "Volume Liquid"
}
