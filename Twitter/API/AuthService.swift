//
//  AuthService.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/27/23.
//

import UIKit
import Firebase
import FirebaseAuth

struct AuthCredential{
    let email:String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService{
    static let shared = AuthService()
    
    func registerUser(credentials: AuthCredential,completion: @escaping (Error?,DatabaseReference) -> Void){
        
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 1) else {return}
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child("\(filename)")
        
        
        storageRef.putData(imageData) { meta, error in
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: email, password: password){ (result,error) in
                    if let error = error{
                        print("Debug -> \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else {return}
                    
                    let values = [
                        "email":email,
                        "username":username,
                        "fullname":fullname,
                        "profileImageUrl": profileImageUrl
                    ]
                    
                    REF_USERS.child(uid).updateChildValues(values,withCompletionBlock: completion)
                    
                }
            }
        }
    }
    
    func login(email:String,password:String,completion: @escaping(AuthDataResult?, Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
    }
}
