//
//  UserService.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/27/23.
//

import Foundation
import Firebase
import UIKit

typealias DatabaseCompletion = (Error?, DatabaseReference) -> Void

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
    
    func followUser(uid:String,completion: @escaping DatabaseCompletion){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid:1]) { error, ref in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid:1], withCompletionBlock: completion)
            
        }
    }
    
    func unfollowUser(uid:String,completion: @escaping DatabaseCompletion){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { error, ref in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
        
    }
    
    func checkIfUserIsFollowed(uid:String,completion: @escaping (Bool) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid:String,completion: @escaping (UserRelationStats) -> Void){
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    func saveUserData(user:User,completion:@escaping DatabaseCompletion){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = [
            "fullname":user.fullname,
            "username":user.username,
            "bio": user.bio ?? ""
        ]
        
        REF_USERS.child(uid).updateChildValues(values,withCompletionBlock: completion)
    }
    
    func updateProfileImage(image: UIImage,completion:@escaping (URL) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData) { meta, error in
            ref.downloadURL { url, error in
                guard let url = url else {return}
                let values = ["profileimageUrl": url.absoluteString]
                
                REF_USERS.child(uid).updateChildValues(values) { error, ref in
                    completion(url)
                }
            }
        }
    }
    
    func fetchUser(withUsername username: String,completion: @escaping (User) -> Void){
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else {return}
            self.fetchUser(uid: uid, completion: completion)
        }
    }
    
}
