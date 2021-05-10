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
    
    var admin_table = Table("admin_table2")
    var adminId = Expression<Int>("adminId")
    var admin_username = Expression<String>("admin_username")
    var admin_password = Expression<String>("admin_password")
    
    var symp = Symptom.self
    var symptom_table = Table("symptomTable2")
    var symptomId = Expression<Int>("symptomId")
    var fever = Expression<String>("fever")
    var cough = Expression<String>("cough")
    var sore_throat = Expression<String>("sore_throat")
    var shortnes_of_breath = Expression<String>("shortness_of_breath")
    var headeche = Expression<String>("headeche")
    var age_60_and_above = Expression<Bool>("age_60_and_above")
    var as_gender = Expression<Bool>("as_gender")
    var admin_Id = Expression<Int>("admin_Id")
    var user_Id = Expression<Int>("user_Id")
    
    static func createTable() {
        guard let database = DataBaseModel.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            
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
    //MARK:- Admin Methods
    
    func createAdminTable() {
        do {
            if let database = DataBaseModel.sharedInstance.database {
                try database.run(admin_table.create(ifNotExists:  true, block: { (t) in
                    t.column(adminId, primaryKey: true)
                    t.column(admin_username, unique: true)
                    t.column(admin_password)
                }))
            }
        } catch  {
            print(error.localizedDescription)
        }
        var admin1 = Admin(adminId: 1, admin_username: "", admin_password: "")
        admin1.adminId = 123
        admin1.admin_username = "Ilayda"
        admin1.admin_password = "kodal"
        registerAdmin(adminValues: admin1)
        var admin2 = Admin(adminId: 1, admin_username: "", admin_password: "")
        admin2.adminId = 456
        admin2.admin_username = "Elifipek"
        admin2.admin_password = "uzun"
        registerAdmin(adminValues: admin2)
    }
    
    func registerAdmin(adminValues: Admin) {
        
        do {
            if let database = DataBaseModel.sharedInstance.database {
                try database.run(admin_table.insert(adminId <- adminValues.adminId,
                                                    admin_username <- adminValues.admin_username,
                                                    admin_password <- adminValues.admin_password))
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func getAdminList() -> [Admin]? {
        var admins: [Admin] = []
        do {
            if let thisTable = try DataBaseModel.sharedInstance.database?.prepare(admin_table){
                for each in thisTable{
                    var model = Admin(adminId: 1, admin_username: "", admin_password: "")
                    model.adminId = each[adminId]
                    model.admin_username = each[admin_username]
                    model.admin_password = each[admin_password]
                    admins.append(model)
                }
            }
        } catch  {
            print(error.localizedDescription)
        }
        return admins
    }
    
    func getAdmin(adminUsername: String) -> Admin? {
        var admin = Admin(adminId: 1, admin_username: "", admin_password: "")
        do {
            if let database = DataBaseModel.sharedInstance.database {
                let singleAdmin = try database.prepare(admin_table.filter(admin_username == adminUsername))
                try singleAdmin.forEach { (row) in
                    admin.adminId = try row.get(adminId)
                    admin.admin_username = try row.get(admin_username)
                    admin.admin_password = try row.get(admin_password)
                }
                
            }
        } catch {
            print(error.localizedDescription)
        }
        return admin
    }
    
    func checkAdminUser(username: String, password: String) -> Bool {
        var adminPassword = ""
        
        do {
            if let adminTable = try DataBaseModel.sharedInstance.database?.prepare(admin_table){
                for a in adminTable{
                    let adminUsername = try a.get(admin_username)
                    if adminUsername == username {
                        adminPassword = try a.get(admin_password)
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        if adminPassword == password{
            return true
        }else{
            return false
        }
    }
    
    //MARK:- SignUp user method
    // Inserting user
    static func insertRow(_ userValues: User) {
        let database = DataBaseModel.sharedInstance.database
        do {
            try database?.run(table.insert(name <- userValues.name,
                                           surname <- userValues.surname,
                                           userName <- userValues.userName,
                                           gender <- userValues.gender,
                                           dateOfBirth <- userValues.dateOfBirth,
                                           userPassword <- userValues.userPassword))
        } catch let error {
            print("Insertion failed: \(error)")
        }
    }
    
    // Updating user
    static func updateRow(_ userValues: User) -> Bool? {
        guard let database = DataBaseModel.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        let user = table.filter(id == userValues.id).limit(1)
        
        do {
            
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
                let userObject = User(id: idValue,
                                      userName: userNameValue,
                                      name: nameValue,
                                      surname: surnameValue,
                                      gender: genderValue,
                                      dateOfBirth: dateOfBirthValue,
                                      userPassword: userPasswordValue).self
                userArray.append(userObject)
            }
        } catch {
            print("Present row error: \(error)")
        }
        return userArray
    }
    
    // Delete user
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
    
    //MARK:- Login User Methods
    public func checkUserLogin(username: String, password: String) -> Bool {
        var passwordValue: String = ""
        do {
            if let userTable = try DataBaseModel.sharedInstance.database?.prepare(DataBaseCommands.table) {
                for u in userTable {
                    let usernameValue = try u.get(DataBaseCommands.userName)
                    if usernameValue == username{
                        print(try u.get(DataBaseCommands.userName))
                        print(try u.get(DataBaseCommands.userPassword))
                        passwordValue = try u.get(DataBaseCommands.userPassword)
                    }
                }
            }
        } catch  {
            print(error.localizedDescription)
        }
        if password == passwordValue {
            return true
        } else {
            return false
        }
    }
    
    func getUserwithUsername(userNameValue: String) -> User? {
        var user_model = User(id: 1, userName: "", name: "", surname: "", gender: true, dateOfBirth: "".dateFromISO8601!, userPassword: "")
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
    
    func updatePassword(newUserPassword: String, userValue: User) {
        let user = DataBaseCommands.table.filter(DataBaseCommands.id == userValue.id)
        do {
            
            try DataBaseModel.sharedInstance.database!.run(user.update(DataBaseCommands.name <- userValue.name,
                                                                       DataBaseCommands.surname <- userValue.surname,
                                                                       DataBaseCommands.userName <- userValue.userName,
                                                                       DataBaseCommands.gender <- userValue.gender,
                                                                       DataBaseCommands.dateOfBirth <- userValue.dateOfBirth,
                                                                       DataBaseCommands.userPassword <- newUserPassword))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK:- Symptom methods
    
    func createSymptomTable() {
        do {
            if let database = DataBaseModel.sharedInstance.database {
                try database.run(symptom_table.create(ifNotExists: true) { t in
                    t.column(symptomId, primaryKey: true)
                    t.column(fever)
                    t.column(cough)
                    t.column(sore_throat)
                    t.column(shortnes_of_breath)
                    t.column(headeche)
                    t.column(age_60_and_above)
                    t.column(as_gender)
                    t.column(admin_Id)
                    t.column(user_Id)
                    t.foreignKey(admin_Id, references: admin_table, adminId)
                    t.foreignKey(user_Id, references: DataBaseCommands.table, DataBaseCommands.id)
                })
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func insertSymptoms(symptomValues: Symptom){
        do {
            if let database = DataBaseModel.sharedInstance.database {
                try database.run(symptom_table.insert(fever <- symptomValues.fever, cough <- symptomValues.cough, sore_throat <- symptomValues.sore_throat, shortnes_of_breath <- symptomValues.shortness_of_breath,
                                                      headeche <- symptomValues.headeche, age_60_and_above <- symptomValues.age_60_and_above,
                                                      as_gender <- symptomValues.as_gender,
                                                      admin_Id <- symptomValues.admin_Id,
                                                      user_Id <- symptomValues.user_Id))
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
    func symptomList() -> [Symptom]?{
        var symtomModels: [Symptom] = []
        symptom_table = symptom_table.order(DataBaseCommands.id.desc)
        
        do {
            if let thisTable = try DataBaseModel.sharedInstance.database?.prepare(symptom_table){
                for s in thisTable{
                    var model = Symptom(symptomId: 1, fever: "", cough: "", sore_throat: "", shortness_of_breath: "", headeche: "", as_gender: true, age_60_and_above: true, admin_Id: 1, user_Id: 1)
                    
                    model.symptomId = s[symptomId]
                    model.fever = s[fever]
                    model.cough = s[cough]
                    model.sore_throat = s[sore_throat]
                    model.shortness_of_breath = s[shortnes_of_breath]
                    model.headeche = s[headeche]
                    model.age_60_and_above = s[age_60_and_above]
                    model.as_gender = s[as_gender]
                    model.admin_Id = s[admin_Id]
                    model.user_Id = s[user_Id]
                    symtomModels.append(model)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return symtomModels
    }
    func getSymptom(symptomIdValue: Int) -> Symptom?{
        var symptomSingle = Symptom(symptomId: 1, fever: "", cough: "", sore_throat: "", shortness_of_breath: "", headeche: "", as_gender: true, age_60_and_above: true, admin_Id: 1, user_Id: 1)
        do {
            if let a_symptom = try DataBaseModel.sharedInstance.database?.prepare(symptom_table.filter(symptomId == symptomIdValue)){
                try a_symptom.forEach({ (row) in
                    symptomSingle.symptomId = try row.get(symptomId)
                    symptomSingle.fever = try row.get(fever)
                    symptomSingle.cough = try row.get(cough)
                    symptomSingle.sore_throat = try row.get(sore_throat)
                    symptomSingle.shortness_of_breath = try row.get(shortnes_of_breath)
                    symptomSingle.headeche = try row.get(headeche)
                    symptomSingle.age_60_and_above = try row.get(age_60_and_above)
                    symptomSingle.as_gender = try row.get(as_gender)
                    symptomSingle.admin_Id = try row.get(admin_Id)
                    symptomSingle.user_Id = try row.get(user_Id)
                })
            }
        } catch  {
            print(error.localizedDescription)
        }
        return symptomSingle
    }
    
    func getAdminInSymtomTable(symptomValues: Symptom) -> Admin {
        var thisAdmin = Admin(adminId: 1, admin_username: "", admin_password: "")
        do {
            if let query = try DataBaseModel.sharedInstance.database?.prepare(symptom_table.filter(symptomId == symptomValues.symptomId)){
                try query.forEach({ (row) in
                    thisAdmin.adminId = try row.get(admin_Id)
                })
            }
        } catch  {
            print(error.localizedDescription)
        }
        return thisAdmin
    }
    
    func getUserInSymptomTable(symptomValues: Symptom) -> User? {
        var thisUser = User(id: 1, userName: "", name: "", surname: "", gender: true, dateOfBirth: "".dateFromISO8601!, userPassword: "")
        do {
            if let query = try DataBaseModel.sharedInstance.database?.prepare(symptom_table.filter(symptomId == symptomValues.symptomId)){
                try query.forEach ({ (row) in
                    thisUser.id = try row.get(user_Id)
                })
            }
        } catch  {
            print(error.localizedDescription)
        }
        return thisUser
    }
    
    func deleteAdminSymptom(symptomIdValue: Int) {
        symptom_table = symptom_table.order(DataBaseCommands.id.desc)
        do {
            if let database = DataBaseModel.sharedInstance.database {
                try database.run(symptom_table.filter(symptomId == symptomIdValue).limit(1).delete())
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func createTable() {
        do {
            if let database = DataBaseModel.sharedInstance.database {
                try database.run(DataBaseCommands.table.create(ifNotExists: true) { t in
                    t.column(DataBaseCommands.id, primaryKey: true)
                    t.column(DataBaseCommands.userName , unique: true)
                    t.column(DataBaseCommands.name)
                    t.column(DataBaseCommands.surname)
                    t.column(DataBaseCommands.gender)
                    t.column(DataBaseCommands.dateOfBirth)
                    t.column(DataBaseCommands.userPassword)
                    
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
