//
//  IndexFormatter.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/18/21.
//

import Foundation

extension Int {
    
    func toBool () -> Bool? {
        switch self {
        case 0:
            return false
        case 1:
            return true
        default:
            return nil
        }
    }
}


