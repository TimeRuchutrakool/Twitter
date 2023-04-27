//
//  User.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/27/23.
//

import Foundation

struct User{
    
    let uid:String
    let email:String
    let fullname: String
    let username: String
    let profileImage: String
    
    init(uid:String,dict:[String:AnyObject]) {
        self.uid = uid
        self.email = dict["email"] as? String ?? ""
        self.fullname = dict["fullname"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.profileImage = dict["profileImage"] as? String ?? ""
    }
    
}
