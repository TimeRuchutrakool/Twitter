//
//  NotificationService.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/3/23.
//

import Foundation
import Firebase

struct NotificationService{
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType,tweet: Tweet? = nil,user: User? = nil){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var values: [String:Any] = [
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "uid": uid,
            "type": type.rawValue
        ]
        if type == .mention{
            guard let tweetID = tweet?.tweetID else {return}
            values["tweetID"] = tweetID
        }
        
        if let tweet = tweet{
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        }else if let user = user{
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
        }
        
        
    }
    
    func fetchNotifications(completion: @escaping ([Notification]) -> Void){
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let data = snapshot.value as? [String:AnyObject] else {return}
            guard let uid = data["uid"] as? String else {return}
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, data: data)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}
