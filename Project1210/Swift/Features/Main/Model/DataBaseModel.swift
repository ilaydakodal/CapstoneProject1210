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
    
    func connection(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("user").appendingPathExtension("sqlite3")
            var database = try Connection(fileUrl.path)
            database = db
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
    func registerUser() {
        print("SignUp button tapped")

    }
}
