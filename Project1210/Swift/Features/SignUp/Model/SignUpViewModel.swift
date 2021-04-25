//
//  SignUpViewModel.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/25/21.
//

import Foundation

class SignUpViewModel {
    
    private var userValues: User?
    var user: UserInfoPresentation!
    
    var id: Int?
    var userName: String?
    var name: String?
    var surname: String?
    var gender: Bool?
    var dateOfBirth: Date?
    var userPassword: String?
    
    init(userValues: User?) {
        self.userValues = userValues
        
        self.id = userValues?.id
        self.userName = userValues?.userName
        self.name = userValues?.name
        self.surname = userValues?.surname
        self.gender = userValues?.gender
        self.dateOfBirth = userValues?.dateOfBirth
        self.userPassword = userValues?.userPassword
    }
}
