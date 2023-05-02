//
//  User.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/27/23.
//

import Foundation
import Firebase

struct User{
    
    let uid:String
    let email:String
    let fullname: String
    let username: String
    var profileImageURL: URL!
    
    var isCurrentUser: Bool {return Auth.auth().currentUser?.uid == uid}
    var isFollow = false
    var stats: UserRelationStats?
    
    init(uid:String,dict:[String:AnyObject]) {
        self.uid = uid
        self.email = dict["email"] as? String ?? ""
        self.fullname = dict["fullname"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        if let profileImageURL = dict["profileImageUrl"] as? String{
            self.profileImageURL =  URL(string: profileImageURL)
        }
    }
    
}

struct UserRelationStats{
    var followers: Int
    var following: Int
}
