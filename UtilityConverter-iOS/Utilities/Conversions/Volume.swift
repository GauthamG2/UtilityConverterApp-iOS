//
//  Volume.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-23.
//

import Foundation

enum VolumeUnit {
    case litre
    case millilitre
    case UKgallon
    case UKpint
    case fluidOunce
    
    static let getAllUnits = [litre, millilitre, UKgallon, UKpint, fluidOunce]
}

struct Volume {
    let value: Double
    let unit: VolumeUnit
    
    init(unit: VolumeUnit, value: Double) {
        self.value = value
        self.unit = unit
    }
    
    func convert(unit to: VolumeUnit) -> Double {
        var output = 0.0
        
        switch unit {
        case .litre:
            if to == .millilitre {
                output = value * 1000
            } else if to == .UKgallon {
                output = value / 3.785
            } else if to == .UKpint {
                output = value * 1.76
            } else if to == .fluidOunce {
                output = value * 35.195
            }
        case .millilitre:
            if to == .litre {
                output = value / 1000
            } else if to == .UKgallon {
                output = value / 3785.412
            } else if to == .UKpint {
                output = value / 568.261
            } else if to == .fluidOunce {
                output = value / 28.413
            }
        case .UKgallon:
            if to == .litre {
                output = value * 4.546
            } else if to == .millilitre {
                output = value * 4546.09
            } else if to == .UKpint {
                output = value * 8
            } else if to == .fluidOunce {
                output = value * 160
            }
        case .UKpint:
            if to == .litre {
                output = value / 1.76
            } else if to == .millilitre {
                output = value * 568.261
            } else if to == .UKgallon {
                output = value / 8
            } else if to == .fluidOunce {
                output = value * 20
            }
        case .fluidOunce:
            if to == .litre {
                output = value / 35.195
            } else if to == .millilitre {
                output = value * 28.413
            } else if to == .UKgallon {
                output = value / 160
            } else if to == .UKpint {
                output = value / 20
            }
        }
        
        return output
    }
}
