//
//  DataBaseModel.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/25/21.
//

import Foundation
import SQLite

public class DataBaseModel {
    
    static let sharedInstance = DataBaseModel()
    var database: Connection?
    
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("userList").appendingPathExtension("sqlite3")
            
            database = try Connection(fileUrl.path)
        } catch {
            print("Creating connection to database error: \(error)")
        }
    }
    
    func createTable() {
        let db = DataBaseCommands()
        db.createUserTable()
        db.createAdminTable()
        db.createSymptomTable()
        db.guestTable()
    }
}
