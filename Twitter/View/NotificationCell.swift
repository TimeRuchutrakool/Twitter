//
//  NotificationCell.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/3/23.
//

import UIKit

protocol NotificationCellDelegate: AnyObject{
    func didTapProfile(_ cell: NotificationCell)
    func didTappedFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell{
    
    //MARK: - Properties
    weak var delegate: NotificationCellDelegate?
    
    var notification: Notification?{
        didSet{
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.setDimensions(width: 40, height: 40)
        image.layer.cornerRadius = 40/2
        image.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        
        return image
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    let notificationLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test Notification"
        return label
    }()
    
    //MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,notificationLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        addSubview(stack)
        stack.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        stack.anchor(right: rightAnchor,paddingRight: 12)
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 88, height: 32)
        followButton.layer.cornerRadius = 32/2
        followButton.anchor(right: rightAnchor,paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleProfileImageTapped(){
        delegate?.didTapProfile(self)
        print("Debug -> tapped profile")
    }
    
    @objc func handleFollowTapped(){
        delegate?.didTappedFollow(self)
    }
    
    func configure(){
        guard let notification = notification else {return}
        let vm = NotificationViewModel(notification: notification)
        profileImageView.sd_setImage(with: vm.profileImageUrl)
        notificationLabel.attributedText = vm.notificationText
        followButton.isHidden = vm.shouldHideFollowButton
        followButton.setTitle(vm.followButtonText, for: .normal)
    }
    
}
