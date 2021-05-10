//
//  AdminCellModel.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/5/21.
//

import Foundation

struct AdminSymptomCell {
    
    let database = DataBaseModel.sharedInstance.database
    let databaseCommands = DataBaseCommands()
    var adminSymptomCellId: Int
    var symptomCellId: Int
    var userIdCell: Int
    var feverCell: String
    var coughCell: String
    var genderCell: Bool
    var age_60_and_aboveCell: Bool
    var sore_throatCell: String
    var shortness_of_breathCell: String
    var locationCell: String
   
    
    init(symptomValues: Symptom){
        symptomCellId = symptomValues.symptomId
        adminSymptomCellId = symptomValues.admin_Id
        userIdCell = symptomValues.user_Id
        feverCell = symptomValues.fever
        locationCell = ""
        coughCell = ""
        genderCell = false
        age_60_and_aboveCell = false
        sore_throatCell = ""
        shortness_of_breathCell = ""
    }
    
    func deleteRow()  {
        databaseCommands.deleteAdminSymptom(symptomIdValue: symptomCellId)
    }
}
