//
//  UserCell.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/29/23.
//

import UIKit

class UserCell: UITableViewCell{
    
    //MARK: - Properties
    
    var user: User?{
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
        
        return image
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Testone"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test one"
        return label
    }()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor,paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        guard let  user = user else {return}
        
        profileImageView.sd_setImage(with: user.profileImageURL)
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }
}
