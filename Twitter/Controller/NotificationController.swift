//
//  NotificationController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/26/23.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController{
    
    //MARK: - Properties
    private var notifications = [Notification](){
        didSet{
            tableView.reloadData()
        }
    }
    
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
       fetchNotifications()
    }
    
    //MARK: - API
   
    
    func fetchNotifications(){
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { notifications in
            self.refreshControl?.endRefreshing()
            self.notifications = notifications
            
            self.checkIfUserIsFollowed(notifications)
        }
        
    }
    
    func checkIfUserIsFollowed(_ notifications: [Notification]) {
        for (index,noti) in notifications.enumerated(){
            if case .follow = noti.type{
                let user = noti.user
                UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                    self.notifications[index].user.isFollow = isFollowed
                }
            }
        }
    }
    
    //MARK: - Functions
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh(){
        fetchNotifications()
        
    }
    
}

extension NotificationController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else {return}
        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension NotificationController: NotificationCellDelegate{
    func didTapProfile(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTappedFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        if user.isFollow{
            print("Debug -> to unfollow")
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                cell.notification?.user.isFollow = true
            }
        }
        else{
            print("Debug -> to follow")
            UserService.shared.followUser(uid: user.uid) { error, ref in
                cell.notification?.user.isFollow = true
            }
        }
    }
}
