//
//  DataBaseModel.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/17/21.
//

import Foundation
import SQLite

class DataBaseModel {
    
    var db = try! Connection()
    var signUp = SignUpViewController.self
    
    let user = Table("user")
    let userId = Expression<Int64>("userId")
    let userName = Expression<String?>("userName")
    let name = Expression<String>("name")
    let surname = Expression<String>("surname")
    let gender = Expression<Bool>("gender")
    let dateOfBirth = Expression<Date>("dateOfBirth")
    let userPassword = Expression<String>("userPassword")
    
    let symptomQuestions = Table("symptomQuestions")
    let adminId = Expression<Int64>("adminId")
    let fever = Expression<String>("fever")
    let cough  = Expression<String>("cough")
    let sore_throat  = Expression<Bool>("sore_throat")
    let shortness_of_breath  = Expression<Date>("shortness_of_breath")
    let headache  = Expression<String>("headache")
    let age_60_and_above  = Expression<String>("age_60_and_above")
    let gender_1  = Expression<String>("gender")
    
    func connection(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("user").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            db = database
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        let createTable = self.user.create { (table) in
            table.column(self.userId, primaryKey: true)
            table.column(self.userName, unique: true)
            table.column(self.name)
            table.column(self.surname)
            table.column(self.gender)
            table.column(self.dateOfBirth)
            table.column(self.userPassword)
        }
        do {
            try db.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
    }
<<<<<<< Updated upstream
=======
    func registerUser() {
        print("SignUp button tapped")

    }
    
>>>>>>> Stashed changes
}
