//
//  Notification.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/3/23.
//

import Foundation

enum NotificationType: Int{
    case follow
    case like
    case reply
    case retweet
    case mention
    

}

struct Notification{
    
    var tweetID: String?
    var timestamp: Date!
    var user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, data: [String:AnyObject]) {
        self.user = user
        
        if let tweetID = data["tweetID"] as? String{
            self.tweetID = tweetID
        }
        
        if let timestamp = data["timestamp"] as? Double{
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        if let type = data["type"] as? Int{
            self.type = NotificationType(rawValue: type)
        }
    }
}
