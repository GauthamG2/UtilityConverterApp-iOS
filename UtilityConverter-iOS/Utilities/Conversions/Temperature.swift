//
//  Temperature.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-23.
//

import Foundation

enum TemperatureUnit {
    case celsius
    case fahrenheit
    case kelvin
    
    static let getAllUnits = [celsius, fahrenheit, kelvin]
}

struct Temperature {
    let value: Double
    let unit: TemperatureUnit
    
    init(value: Double, unit: TemperatureUnit) {
        self.unit = unit
        self.value = value
    }
    
    func convert(unit to: TemperatureUnit) -> Double {
        var output = 0.0
        
        switch unit {
        case .celsius:
            if to == .fahrenheit {
                output = (value * 9 / 5) + 32
            } else if to == .kelvin {
                output = value + 273.15
            }
        case .fahrenheit:
            if to == .celsius {
                output = (value - 32) * 5 / 9
            } else if to == .kelvin {
                output = ((value - 32) * 5 / 9) + 273.15
            }
        case .kelvin:
            if to == .celsius {
                output = value - 273.15
            } else if to == .fahrenheit {
                output = ((value - 273.15) * 9 / 5) + 32
            }
        }
        return output
    }
}
