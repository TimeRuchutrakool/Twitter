//
//  NotificationViewModel.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/3/23.
//

import Foundation
import UIKit

struct NotificationViewModel{
    
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timestampString: String?{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? ""
    }
    
    var notificationMessage: String{
        switch type{
        case .follow:
            return " stated following you "
        case .like:
            return " liked one of your tweet "
        case .reply:
            return " replied to your tweet "
        case .retweet:
            return " retweeted your tweet "
        case .mention:
            return " mentioned you in their tweet "
        }
    }
    
    var notificationText: NSAttributedString?{
        guard let timestamp = timestampString else {return nil}
        let attributedTitle = NSMutableAttributedString(string: user.username, attributes: [.font:UIFont.boldSystemFont(ofSize: 12)])
        attributedTitle.append(NSAttributedString(string: notificationMessage, attributes: [.font:UIFont.systemFont(ofSize: 12)]))
        attributedTitle.append(NSAttributedString(string:"\(timestamp)", attributes: [.font:UIFont.systemFont(ofSize: 12),.foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    var profileImageUrl: URL?{
        return user.profileImageURL
    }
    
    var shouldHideFollowButton: Bool{
        return type != .follow
    }
    
    var followButtonText: String{
        return user.isFollow ? "Following" : "Follow"
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
    
}
