//
//  FeedController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/26/23.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController{
    
    //MARK: - Properties
    var user: User?{
        didSet{
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
       fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    func fetchTweets(){
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweet { tweets in
           
            self.tweets = tweets.sorted(by: {$0.timeStamp > $1.timeStamp})
            self.checkIfUserLikedTweets()
            
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedTweets() {
        self.tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikeTweet(tweet) { didLike in
                guard didLike == true else {return}
                
                if let index = self.tweets.firstIndex(where: {$0.tweetID == tweet.tweetID}){
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    
    //MARK: - Functions
    
    func configureUI(){
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let refrshControl = UIRefreshControl()
        refrshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refrshControl
    }
    
    @objc func handleRefresh(){
        fetchTweets()
    }
    
    func configureLeftBarButton(){
        guard let user = user else {return}
        let profileImageView = UIImageView()
        //profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true
        profileImageView.sd_setImage(with: user.profileImageURL, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
    }
    
}

extension FeedController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row]
        let vm = TweetViewModel(tweet: tweet)
        let height = vm.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height+80)
    }
    
}

extension FeedController: TweetCellDelegate{
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    func handleLikesTapped(_ cell: TweetCell) {
        
        guard let tweet = cell.tweet else {return}
        TweetService.shared.likeTweet(tweet: tweet) { error, ref in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            //only upload noti if tweet is being liked
            guard !tweet.didLike else {return}
            NotificationService.shared.uploadNotification(type: .like,tweet: tweet)
        }
        
    }
    
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
 
}
