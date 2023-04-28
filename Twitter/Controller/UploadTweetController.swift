//
//  UploadTweetController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/28/23.
//

import UIKit
import SDWebImage

class UploadTweetController: UIViewController{
    
    //MARK: - Properties
    
    private let user: User
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.setDimensions(width: 48, height: 48)
        image.layer.cornerRadius = 48/2
        image.backgroundColor = .twitterBlue
        return image
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK: - Life Cycle
    
    init(user:User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    
    //MARK: - API
    
    //MARK: - Function
    private func layout(){
        view.backgroundColor = .white
        configureNavBar()
        
        let stack = UIStackView(arrangedSubviews: [
            profileImageView,captionTextView
        ])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 16,paddingRight: 16)
        profileImageView.sd_setImage(with: user.profileImageURL)
    }
    
    private func configureNavBar(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    @objc func handleCancel(){
        dismiss(animated: true)
    }
    
    @objc func handleUploadTweet(){
        guard let caption = captionTextView.text else {return}
        TweetService.shared.uploadTweet(caption: caption) { error, ref in
            if let error = error{
                print("Debug -> \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
}
