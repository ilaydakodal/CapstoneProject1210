//
//  AdminModel.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/5/21.
//

import Foundation

struct Admin {
    static var shared: Admin?
    
    var adminId: Int
    var admin_username: String
    var admin_password: String
}
