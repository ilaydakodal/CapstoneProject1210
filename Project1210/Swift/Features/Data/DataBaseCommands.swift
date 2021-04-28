//
//  DataBaseCommands.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/25/21.
//

import Foundation
import SQLite

class DataBaseCommands {
    
    static var table = Table("user")
    
    static let id = Expression<Int>("id")
    static let userName = Expression<String>("userName")
    static let name = Expression<String>("name")
    static let surname = Expression<String>("surname")
    static let gender = Expression<Bool>("gender")
    static let dateOfBirth = Expression<Date>("dateOfBirth")
    static let userPassword = Expression<String>("userPassword")
    
    static func createTable() {
        guard let database = DataBaseModel.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            // ifNotExists: true - Will NOT create a table if it already exists
            try database.run(table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(userName, unique: true)
                table.column(name)
                table.column(surname)
                table.column(gender)
                table.column(dateOfBirth)
                table.column(userPassword)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    // Inserting Row
    static func insertRow(_ userValues: User) -> Bool? {
        guard let database = DataBaseModel.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        do {
            try database.run(table.insert(name <- userValues.name,
                                          surname <- userValues.surname,
                                          userName <- userValues.userName,
                                          gender <- userValues.gender,
                                          dateOfBirth <- userValues.dateOfBirth,
                                          userPassword <- userValues.userPassword))
            return true
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
    }
    
    // Updating Row
    static func updateRow(_ userValues: User) -> Bool? {
        guard let database = DataBaseModel.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        let user = table.filter(id == userValues.id).limit(1)
        
        do {
            // Update the contact's values
            if try database.run(user.update(name <-  userValues.name,
                                            surname <- userValues.surname,
                                            userName <- userValues.userName,
                                            gender <- userValues.gender,
                                            dateOfBirth <- userValues.dateOfBirth,
                                            userPassword <- userValues.userPassword)) > 0 {
                print("Updated user")
                return true
            } else {
                print("Could not update users: user not found")
                return false
            }
        } catch let error {
            print("Updation failed: \(error)")
            return false
        }
    }
    
    // Present Rows
    static func presentRows() -> [User]? {
        guard let database = DataBaseModel.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        var userArray: [User] = []
        
        // Sorting data in descending order by ID
        table = table.order(id.desc)
        
        do {
            for user in try database.prepare(table) {
                let idValue = user[id]
                let nameValue = user[name]
                let surnameValue = user[surname]
                let userNameValue = user[userName]
                let genderValue = user[gender]
                let dateOfBirthValue = user[dateOfBirth]
                let userPasswordValue = user[userPassword]
                
                // Create object
                let userObject = User(id: idValue, userName: userNameValue, name: nameValue, surname: surnameValue, gender: genderValue, dateOfBirth: dateOfBirthValue, userPassword: userPasswordValue).self
                
                // Add object to an array
                userArray.append(userObject)
                
                //print("id \(user[id]), firstName: \(user[firstName]), lastName: \(user[lastName]), phoneNumber: \(user[phoneNumber]), photo: \(contact[photo])")
            }
        } catch {
            print("Present row error: \(error)")
        }
        return userArray
    }
    
    // Delete Row
    static func deleteRow(userId: Int) {
        guard let database = DataBaseModel.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            let user = table.filter(id == userId).limit(1)
            try database.run(user.delete())
        } catch {
            print("Delete row error: \(error)")
        }
    }
    
    func getUserwithUsername(userNameValue: String) -> User? {
        var user_model = User(id: 0,
                              userName: "",
                              name: "",
                              surname: "",
                              gender: true,
                              dateOfBirth: "".dateFromISO8601!,
                              userPassword: "")
        
        let database = DataBaseModel.sharedInstance.database
        
        do {
            let singleUser: AnySequence<Row> = try database!.prepare(DataBaseCommands.table.filter(DataBaseCommands.userName == userNameValue))
            
            try singleUser.forEach({ (rowValue) in
                user_model.id = try rowValue.get(DataBaseCommands.id)
                user_model.name = try rowValue.get(DataBaseCommands.name)
                user_model.surname = try rowValue.get(DataBaseCommands.surname)
                user_model.userName = try rowValue.get(DataBaseCommands.userName)
                user_model.gender = try rowValue.get(DataBaseCommands.gender)
                user_model.dateOfBirth = try rowValue.get(DataBaseCommands.dateOfBirth)
                user_model.userPassword = try rowValue.get(DataBaseCommands.userPassword)
            })
        } catch  {
            print(error.localizedDescription)
        }
        return user_model
    }
}
