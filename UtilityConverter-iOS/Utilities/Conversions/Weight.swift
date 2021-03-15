//
//  Weight.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-21.
//

import Foundation

enum WeightUnit {
    case kilogram
    case gram
    case ounce
    case pound
    case stone
    
    static let getAllUnits = [kilogram, gram, ounce, pound, stone]
}

struct Weight {
    let value : Double
    let unit  : WeightUnit
    
    init(value: Double, unit: WeightUnit) {
        self.value = value
        self.unit  = unit
    }
    
    func convert(unit to: WeightUnit) -> Double {
        var output = 0.0
        
        switch unit {
        case .kilogram:
            if to == .gram {
                output = value * 1000
            } else if to == .ounce {
                output = value * 35.274
            } else if to == .pound {
                output = value * 2.20462
            } else if to == .stone {
                output = value * 0.157473
            }
        case .gram:
            if to == .kilogram {
                output = value / 1000
            } else if to == .ounce {
                output = value / 28.35
            } else if to == .pound {
                output = value / 453.592
            } else if to == .stone {
                output = value / 6350.293
            }
        case .ounce:
            if to == .kilogram {
                output = value / 35.274
            } else if to == .gram {
                output = value * 28.35
            } else if to == .pound {
                output = value / 16
            } else if to == .stone {
                output = value / 224
            }
        case .pound:
            if to == .kilogram {
                output = value / 2.205
            } else if to == .gram {
                output = value * 453.592
            } else if to == .ounce {
                output = value * 16
            } else if to == .stone {
                output = value / 14
            }
        case .stone:
            if to == .kilogram {
                output = value * 6.35
            } else if to == .gram {
                output = value * 6350.293
            } else if to == .pound {
                output = value *  14
            } else if to == .ounce {
                output = value * 224
            }
        }
        return output
    }
}
