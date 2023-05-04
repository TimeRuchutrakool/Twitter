//
//  EditProfileHeader.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/4/23.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject{
    func didTappedChangeProfilePhoto()
}

class EditProfileHeader : UICollectionReusableView{
    
    //MARK: - Properties
    
    weak var delegate: EditProfileHeaderDelegate?
   
    var user: User?{
        didSet{
            configure()
        }
    }
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 3
        image.backgroundColor = .lightGray
        return image
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change profile picture", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func configure(){
        
        backgroundColor = .twitterBlue
        
        addSubview(profileImageView)
        profileImageView.center(inView: self,yConstant: -16)
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100/2
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self,topAnchor: profileImageView.bottomAnchor,paddingTop: 8)
        
        guard let user = user else {return}
        profileImageView.sd_setImage(with: user.profileImageURL)
    }
    
    
    //MARK: - Selectors
    @objc func handleChangePhoto(){
        delegate?.didTappedChangeProfilePhoto()
    }
    
}
