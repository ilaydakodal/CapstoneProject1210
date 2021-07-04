//
//  UserModel.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/25/21.
//

import Foundation
import CoreLocation

struct User {
    static var shared: User?
    
    var id: Int
    var userName: String
    var name: String
    var surname: String
    var gender: Bool
    var dateOfBirth: Date
    var userPassword:String
    var testApplied: Bool = false
    var currentDate: String = ""
    var eventDate: String
    var userLat: CLLocationDegrees = 41.0422
    var userLong: CLLocationDegrees = 29.0093
}



