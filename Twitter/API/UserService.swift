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
    
}
