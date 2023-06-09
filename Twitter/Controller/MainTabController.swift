//
//  MainTabController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/26/23.
//

import UIKit
import Firebase

enum ActionButtonConfiguration{
    case tweet
    case message
}

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
    var user: User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else {return} //main
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            feed.user = user
        }
    }
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.layer.cornerRadius = 56/2
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
        
        //logout()
        authenticateUserAndConfigureUI()
        
    }
    
    //MARK: - API
    
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: true)
            }
        }
        else{
            configVC()
            layout()
            fetchUser()
        }
    }
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        }
        catch let error{
            print("Debug -> \(error.localizedDescription)")
        }
    }
    
    //MARK: - Functions
    
    func configVC(){
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feedNav = templateNavController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = SearchController(config: .userSearch)
        let exploreNav = templateNavController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let noti = NotificationController(collectionViewLayout: UICollectionViewLayout())
        let notiNav = templateNavController(image: UIImage(named: "like_unselected"), rootViewController: noti)
        
        let conver = ConversationController()
        let converNav = templateNavController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conver)
        
        
        UITabBar.appearance().backgroundColor = UIColor.white
        viewControllers = [feedNav,exploreNav,notiNav,converNav]
    }
    
    func templateNavController(image:UIImage?,rootViewController:UIViewController) -> UINavigationController{
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = false
        navigationController.view.backgroundColor = .white
       
        return navigationController
    }
    
    func layout(){
        self.delegate = self
        view.addSubview(actionButton)
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingBottom: 64,paddingRight: 16,width: 56,height: 56)
    }
    
    @objc func actionButtonTapped(){
        
        let controller: UIViewController
        
        switch buttonConfig {
        case .message:
            controller = SearchController(config: .messages)
        case .tweet:
            guard let user = user else {return}
            controller = UploadTweetController(user: user, config: .tweet)
        }
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
}

extension MainTabController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        let imageName = index == 3 ? "mail" : "new_tweet"
        self.actionButton.setImage(UIImage(named: imageName), for: .normal)
        buttonConfig = index == 3 ? .message : .tweet
    }
}
