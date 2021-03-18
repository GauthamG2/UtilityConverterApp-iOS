//
//  HomeVM.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-14.
//

import UIKit

class HomeVM: NSObject {
    
    var arrHomeCollectionView : [Conversions] = []
    
    func getConversionType() {
        
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "weight-128")!, key: .Weight))
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "temperature-128")!, key: .Temperature))
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "length-128")!, key: .Length))
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "speed-128")!, key: .Speed))
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "volume-128")!, key: .VolumeLiquid))
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "date-128")!, key: .Time))
    }
}

struct Conversions {
    var imgIcon : UIImage
    var key     : ConversionsKey
}

enum ConversionsKey: String {
    case Weight       = "Weight"
    case Temperature  = "Temperature"
    case Length       = "Length"
    case Speed        = "Speed"
    case VolumeLiquid = "Volume Liquid"
    case Time         = "Time"
}
