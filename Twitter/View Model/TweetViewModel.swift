//
//  TweetViewModel.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/28/23.
//

import UIKit

struct TweetViewModel{
    
    let tweet: Tweet
    let user: User
    var profileImageURL: URL? {
        return tweet.user.profileImageURL
    }
    
    var userInfoText: NSAttributedString{
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
        title.append(NSAttributedString(string: " · \(timestamp)", attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
        return title
    }
    
    var timestamp: String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timeStamp, to: now) ?? ""
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
}
