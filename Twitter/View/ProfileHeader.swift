//
//  ProfileHeader.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/28/23.
//

import UIKit

class ProfileHeader: UICollectionReusableView{
    
    //MARK: - Properties
    
    private lazy var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor,left: view.leftAnchor,paddingTop: 42,paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 4
        image.backgroundColor = .lightGray
        image.layer.cornerRadius = 80/2
        return image
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        button.layer.cornerRadius = 36/2
        return button
    }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.text = "Test One"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "@TestOne"
        label.font = UIFont.systemFont(ofSize: 16)
        label.tintColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "I like this song so I saved it as my phone ringtone!🥰 This is the BEST Anime song since the Boruto 17th ending song."
        return label
    }()
    
    private let filterBar = ProfileFilterView()
    
    private let underlineView: UIView = {
       let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor,height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor,left: leftAnchor,paddingTop: -24,paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: containerView.bottomAnchor,right: rightAnchor,paddingTop: 12,paddingRight: 12)
        editProfileButton.setDimensions(width: 100, height: 36)
        
        let userInfoStack = UIStackView(arrangedSubviews: [
            fullnameLabel,usernameLabel,bioLabel
        ])
        userInfoStack.axis = .vertical
        userInfoStack.distribution = .fillProportionally
        userInfoStack.spacing = 4
        
        addSubview(userInfoStack)
        userInfoStack.anchor(top: profileImageView.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 8,paddingLeft: 12,paddingRight: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor,bottom: bottomAnchor,width: frame.width/3,height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleBackButton(){
        
    }
    
    @objc func handleEditProfileFollow(){
        
    }
    
}

extension ProfileHeader: ProfileFilterViewDelegate{
    
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) else {return}
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
    
}
