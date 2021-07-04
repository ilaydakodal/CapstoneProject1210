//
//  SymptomModel.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/5/21.
//

import Foundation
import CoreLocation

struct Symptom {
    var symptomId: Int
    var fever: String
    var cough: String
    var sore_throat: String
    var shortness_of_breath: String
    var headeche: String
    var as_gender: Bool
    var age_60_and_above: Bool
    var admin_Id: Int
    var user_Id: Int
    var output: Int64
    var lat: CLLocationDegrees = 41.015137
    var long: CLLocationDegrees = 28.979530
}
