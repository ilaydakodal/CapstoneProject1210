//
//  UserListViewModel.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/25/21.
//

import Foundation

class UserListViewModel {
    
    private var userArray = [User]()
            var changeHandler: ((Change) -> Void)?
    
    enum Change {
        case presentation(presentation: UserInfoPresentation.MainPresentation)
        case alert(message: String)
    }
    
    func connectToDatabase() {
        _ = DataBaseModel.sharedInstance
    }
    
    func loadDataFromSQLiteDatabase() {
        userArray = DataBaseCommands.presentRows() ?? []
    }
    
    func numberOfRowsInSection (section: Int) -> Int {
        if userArray.count != 0 {
            return userArray.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> User {
        return userArray[indexPath.row]
    }
}
