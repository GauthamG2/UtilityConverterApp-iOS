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
        
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "weight")!, key: .Weight))
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "weight")!, key: .Temperature))
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "weight")!, key: .Length))
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "weight")!, key: .Speed))
        arrHomeCollectionView.append(Conversions(imgIcon: UIImage(named: "weight")!, key: .VolumeLiquid))
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
}
