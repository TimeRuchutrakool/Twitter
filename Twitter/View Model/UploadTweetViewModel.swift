//
//  UploadTweetViewModel.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/2/23.
//

import UIKit

enum UploadTweetConfiguration{
    case tweet
    case reply(Tweet)
}


struct UploadTweetViewModel{
    
    let actionButttonTitle: String
    let placeHolderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(configuration: UploadTweetConfiguration){
        switch configuration {
        case .tweet:
            actionButttonTitle = "Tweet"
            placeHolderText = "What's happening?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButttonTitle = "Reply"
            placeHolderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}
