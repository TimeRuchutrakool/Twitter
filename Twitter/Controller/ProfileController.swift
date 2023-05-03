//
//  ProfileController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/28/23.
//

import UIKit

private let reuseidentifier = "TweetCell"
private let headeridentifier = "ProfileHeader"


class ProfileController: UICollectionViewController{
    
    //MARK: - Properties
    private var user: User
    
    private var selectedFilter: ProfileFilterOptions = .tweets{
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replies = [Tweet]()
    
    private var currentDatasource: [Tweet]{
        switch selectedFilter {
        case .tweets:
            return tweets
        case .replies:
            return replies
        case .likes:
            return likedTweets
        }
    }
    
    //MARK: - Life Cycle
    
    init(user:User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        configureCollectionView()
        fetchTweets()
        checkIfUserFollow()
        fetchUserStat()
        fetchLikedTweets()
        fetchReplies()
    }
    
    //MARK: - API
    
    func fetchTweets(){
        TweetService.shared.fetchTweet(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserFollow(){
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollow = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStat(){
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
            
        }
    }
    
    func fetchLikedTweets(){
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets
        }
    }
    
    func fetchReplies(){
        TweetService.shared.fetchReplies(forUser: user) { tweets in
            self.replies = tweets
        }
    }
    
    //MARK: - Functions
    func configureCollectionView(){
        
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseidentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headeridentifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else {return}
        collectionView.contentInset.bottom = tabHeight
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDatasource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath) as! TweetCell
        cell.tweet = currentDatasource[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: currentDatasource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProfileController{
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headeridentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
}


extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 360)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = currentDatasource[indexPath.row]
        let vm = TweetViewModel(tweet: tweet)
        var height = vm.size(forWidth: view.frame.width).height + 72
        
        if currentDatasource[indexPath.row].isReply{
            height += 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
}

extension ProfileController: ProfileHeaderDelegate{
    func profiledissmiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrentUser{
            return
        }
        else{
            if user.isFollow{
                UserService.shared.unfollowUser(uid: user.uid) { Error, ref in
                    self.user.isFollow = false
                    self.collectionView.reloadData()
                }
            }
            else{
                UserService.shared.followUser(uid: user.uid) { error, ref in
                    self.user.isFollow = true
                    self.collectionView.reloadData()
                    NotificationService.shared.uploadNotification(type: .follow,user: self.user)
                }
            }
        }
    }
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
}
