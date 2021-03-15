//
//  Length.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-23.
//

import Foundation

enum LengthUnit {
    case metre
    case kiloMetre
    case mile
    case centiMetre
    case milliMetre
    case yard
    case inch
    
    static let getAllUnits = [metre, kiloMetre, mile, centiMetre, milliMetre, yard, inch]
}

struct Length {
    let value: Double
    let unit: LengthUnit
    
    init(value: Double, unit: LengthUnit) {
        self.value = value
        self.unit = unit
    }
    
    func convert(unit to: LengthUnit) -> Double {
        var output = 0.0
        
        switch unit {
        case .metre:
            if to == .kiloMetre {
                output = value / 1000
            } else if to == .mile {
                output = value / 1609.244
            } else if to == .centiMetre {
                output = value * 100
            } else if to == .milliMetre {
                output = value * 1000
            } else if to == .yard {
                output = value * 1.094
            } else if to == .inch {
                output = value * 39.37
            }
        case .kiloMetre:
            if to == .metre {
                output = value * 1000
            } else if to == .mile {
                output = value / 1.609244
            } else if to == .centiMetre {
                output = value * 100000
            } else if to == .milliMetre {
                output = value * 1000000
            } else if to == .yard {
                output = value * 1094
            } else if to == .inch {
                output = value * 39370.1
            }
        case .mile:
            if to == .metre {
                output = value * 1609.344
            } else if to == .kiloMetre {
                output = value * 1.60934
            } else if to == .centiMetre {
                output = value * 160934.4
            } else if to == .milliMetre {
                output = value * 1.609e+6
            } else if to == .yard {
                output = value * 1760
            } else if to == .inch {
                output = value * 63360
            }
        case .centiMetre:
            if to == .metre {
                output = value / 100
            } else if to == .kiloMetre {
                output = value / 100000
            } else if to == .mile {
                output = value / 160934
            } else if to == .milliMetre {
                output = value / 10
            } else if to == .yard {
                output = value / 91.44
            } else if to == .inch {
                output = value / 2.54
            }
        case .milliMetre:
            if to == .metre {
                output = value / 1000
            } else if to == .kiloMetre {
                output = value / 1e+6
            } else if to == .mile {
                output = value / 1.609e+6
            } else if to == .centiMetre {
                output = value / 10
            } else if to == .yard {
                output = value / 914
            } else if to == .inch {
                output = value / 25.4
            }
        case .yard:
            if to == .metre {
                output = value / 1.094
            } else if to == .kiloMetre {
                output = value / 1094
            } else if to == .mile {
                output = value / 1760
            } else if to == .centiMetre {
                output = value / 91.44
            } else if to == .milliMetre {
                output = value * 914
            } else if to == .inch {
                output = value * 36
            }
        case .inch:
            if to == .metre {
                output = value / 39.37
            } else if to == .kiloMetre {
                output = value / 39370
            } else if to == .mile {
                output = value / 63360
            } else if to == .centiMetre {
                output = value * 2.54
            } else if to == .milliMetre {
                output = value * 25.4
            } else if to == .yard {
                output = value / 36
            }
        }
        return output
    }
}

