//
//  UserService.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/27/23.
//

import Foundation
import Firebase

struct UserService{
    
    static let shared = UserService()
    
    func fetchUser(uid: String,completion: @escaping (User) -> Void){
       
       
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String:AnyObject] else {return}
            
            let user = User(uid: uid, dict: data)
            completion(user)
            
        }
        
        
    }
    
    func fetchUseers(completion: @escaping ([User]) -> Void){
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let data = snapshot.value as? [String:AnyObject] else {return}
            let user = User(uid: uid, dict: data)
            users.append(user)
            completion(users)
        }
        
    }
    
}
