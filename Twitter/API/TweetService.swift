//
//  TweetService.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/28/23.
//

import Foundation
import Firebase

struct TweetService{
    
    static let shared = TweetService()
    
    func uploadTweet(caption: String,completion: @escaping (Error?,DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = [
            "uid": uid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "likes": 0,
            "retweets": 0,
            "caption": caption
        ] as [String:Any]
        
        REF_TWEETS.childByAutoId().updateChildValues(values,withCompletionBlock: completion)
    }
    
    func fetchTweet(completion: @escaping ([Tweet]) -> Void){
        var tweets: [Tweet] = []
        REF_TWEETS.observe(.childAdded) { snapshot  in
            guard let data = snapshot.value as? [String:Any] else {return}
            let tweetID = snapshot.key
            guard let uid = data["uid"] as? String else {return}
            
            UserService.shared.fetchUser(uid:uid) { user in
                let tweet = Tweet(tweetID: tweetID, data: data, user: user)
                tweets.append(tweet)
                completion(tweets)
                
            }
            
        }
    }
    
}
