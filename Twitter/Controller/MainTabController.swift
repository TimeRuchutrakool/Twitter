//
//  MainTabController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/26/23.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Properties
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

        configVC()
        layout()
    }
    
    //MARK: - Functions
    
    func configVC(){
        
        let feed = FeedController()
        let feedNav = templateNavController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let exploreNav = templateNavController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let noti = NotificationController()
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
        view.addSubview(actionButton)
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingBottom: 64,paddingRight: 16,width: 56,height: 56)
    }
    
    @objc func actionButtonTapped(){
        print("Fuck")
    }
    
}