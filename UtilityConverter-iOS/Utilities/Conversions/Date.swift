//
//  Date.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-03-17.
//

import Foundation

enum TimeUnit {
    case year
    case month
    case day
    case hour
    case minute
    case second
    
    static let gteAllUnits = [year, month, day, hour, minute, second]
}

struct Time {
    let value: Double
    let unit: TimeUnit
    
    init(unit: TimeUnit, value: Double) {
        self.value = value
        self.unit = unit
    }
    
    func convert(unit to: TimeUnit) -> Double {
        var output = 0.0
        
        switch unit {
        case .year:
            if to == .month {
                output = value * 12
            } else if to == .day {
                output = value * 365
            } else if to == .hour {
                output = value * 8760
            } else if to == .minute {
                output = value * 525600
            } else if to == .second {
                output = value * 3.154e+7
            }
        case .month:
            if to == .year {
                output = value / 12
            } else if to == .day {
                output = value * 30.417
            } else if to == .hour {
                output = value * 730
            } else if to == .minute {
                output = value * 43800
            } else if to == .second {
                output = value * 2.628e+6
            }
        case .day:
            if to == .year {
                output = value * 365
            } else if to == .month {
                output = value / 30.417
            } else if to == .hour {
                output = value * 24
            } else if to == .minute {
                output = value * 1440
            } else if to == .second {
                output = value * 86400
            }
        case .hour:
            if to == .year {
                output = value / 8760
            } else if to == .month {
                output = value / 730
            } else if to == .day {
                output = value / 24
            } else if to == .minute {
                output = value * 60
            } else if to == .second {
                output = value * 3600
            }
        case .minute:
            if to == .year {
                output = value / 525600
            } else if to == .month {
                output = value / 43800
            } else if to == .day {
                output = value / 1440
            } else if to == .hour {
                output = value / 60
            } else if to == .second {
                output = value * 60
            }
        case .second:
            if to == .year {
                output = value / 3.154e+7
            } else if to == .month {
                output = value / 2.628e+6
            } else if to == .day {
                output = value / 86400
            } else if to == .hour {
                output = value / 3600
            } else if to == .minute {
                output = value / 60
            }
        }
        
        return output
    }
}
