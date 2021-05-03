//
//  UserInfoPresentation.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/25/21.
//

import Foundation

struct UserInfoPresentation {
    var id: String
    var userName: String
    var name: String
    var surname: String
    var gender: String
    var dateOfBirth: String
    
    public struct MainPresentation {
        let smallInfoPresentation: [UserInfoPresentation]
    }
}
