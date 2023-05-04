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
    var fullname: String
    var username: String
    var profileImageURL: URL!
    
    var isCurrentUser: Bool {return Auth.auth().currentUser?.uid == uid}
    var isFollow = false
    var stats: UserRelationStats?
    
    var bio: String?
    
    init(uid:String,dict:[String:AnyObject]) {
        self.uid = uid
        self.email = dict["email"] as? String ?? ""
        self.fullname = dict["fullname"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        if let profileImageURL = dict["profileImageUrl"] as? String{
            self.profileImageURL =  URL(string: profileImageURL)
        }
        self.bio = dict["bio"] as? String ?? ""
    }
    
}

struct UserRelationStats{
    var followers: Int
    var following: Int
}
