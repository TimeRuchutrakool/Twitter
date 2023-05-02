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
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(configuration: config)
    
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
    
    private lazy var replyLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Reply to @Whore"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    //MARK: - Life Cycle
    
    init(user:User,config:UploadTweetConfiguration){
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        switch config {
        case .tweet:
            print("Debug -> Tweet")
        case .reply(let tweet):
            print("Debug -> Reply to \(tweet.caption)")
        }
    }
    
    //MARK: - API
    
    //MARK: - Function
    private func layout(){
        view.backgroundColor = .white
        configureNavBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [
            profileImageView,captionTextView
        ])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageCaptionStack])
        stack.axis = .vertical
        
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 16,paddingRight: 16)
        
        profileImageView.sd_setImage(with: user.profileImageURL)
        actionButton.setTitle(viewModel.actionButttonTitle, for: .normal)
        captionTextView.placeholder.text = viewModel.placeHolderText
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else {return}
        replyLabel.text = replyText
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
        TweetService.shared.uploadTweet(caption: caption,type: config) { error, ref in
            if let error = error{
                print("Debug -> \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
}
