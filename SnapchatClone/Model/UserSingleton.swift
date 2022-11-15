//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Berke Topcu on 15.11.2022.
//

import Foundation


class UserSingleton {
    
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
}
