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
    
    var usernameText: String{
        return "@\(user.username)"
    }
    
    var headerTimestamp: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return dateFormatter.string(from: tweet.timeStamp)
    }
    
    var retweetAttributedString:NSAttributedString?{
        return attributedText(withValue: tweet.retweetCount, text: " Retweets")
    }
    
    var likesAttributedString:NSAttributedString?{
        return attributedText(withValue: tweet.likes, text: " Likes")
    }
    
    var likeButtonTineColor: UIColor{
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage{
        let imgName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imgName)!
    }
    
    var shouldHideReplyLabel: Bool{
        return !tweet.isReply
    }
    
    var replyText: String?{
        guard let replyToUsername = tweet.replyTo else {return nil}
        return "replying to @\(replyToUsername)"
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    func attributedText(withValue value: Int,text: String) -> NSAttributedString{
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text, attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat) -> CGSize{
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
