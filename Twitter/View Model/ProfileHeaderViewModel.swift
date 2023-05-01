//
//  ProfileHeaderViewMode;.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/29/23.
//

import Foundation
import UIKit

enum ProfileFilterOptions: Int,CaseIterable{
    case tweets
    case replies
    case likes
    
    var descriptions: String{
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        }
    }
}

struct ProfileHeaderViewModel{
    
    private let user: User
    
    let usernameText: String
    
    var followingString: NSAttributedString?{
        return attributedText(withValue: 2, text: " following")
    }
    
    var followersString: NSAttributedString?{
        return attributedText(withValue: 0, text: " followers")
    }
    
    var actionButtonTiTle:String{
        return user.isCurrentUser ? "Edit Profile" : "Loading"
    }
    
    init(user:User){
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    func attributedText(withValue value: Int,text: String) -> NSAttributedString{
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text, attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
        return attributedTitle
    }
    
}
