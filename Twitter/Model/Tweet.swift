//
//  Tweet.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/28/23.
//

import Foundation


struct Tweet{
    
    let caption: String
    let tweetID:String
    let uid:String
    let likes: Int
    var timeStamp: Date!
    let retweetCount: Int
    let user: User
    
    init(tweetID:String, data: [String:Any],user: User){
        self.tweetID = tweetID
        
        self.caption = data["caption"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
        self.likes = data["likes"] as? Int ?? 0
        if let timestamp = data["timestamp"] as? Double{
            self.timeStamp = Date(timeIntervalSince1970: timestamp)
        }
        self.retweetCount = data["retweets"] as? Int ?? 0
        self.user = user
    }
    
}
