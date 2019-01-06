//
//  User.swift
//  GameOfChat
//
//  Created by yuanqi on 2018/9/22.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import Foundation


class User {
    var name: String?
    var mail: String?
    var profileImageUrl: String?
    
    init(dictionary: [String: String]) {
        self.name = dictionary["name"]
        self.mail = dictionary["email"]
        self.profileImageUrl = dictionary["profileImageUrl"]
    }
    
}
