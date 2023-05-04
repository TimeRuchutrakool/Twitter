//
//  TweetController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/2/23.
//

import UIKit

private let reuseidentifier = "TweetCell"
private let headeridentifier = "TweetHeader"

class TweetController: UICollectionViewController{
    
    //MARK: - Properties
    private let tweet: Tweet
    private var replies = [Tweet](){
        didSet{
            collectionView.reloadData()
        }
    }
    private var actionSheetLauncher: ActionSheetLauncher!
    
    //MARK: - Life Cycle
    
    init(tweet:Tweet){
        self.tweet = tweet
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
        
    }
    
    //MARK: - API
    func fetchReplies(){
        TweetService.shared.fetchReplies(fortweet: tweet) { replies in
            self.replies = replies
        }
    }
    
    func configureCollectionView(){

        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseidentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headeridentifier)
    }
    
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
    
}

extension TweetController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headeridentifier, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
    
}

extension TweetController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let vm = TweetViewModel(tweet: tweet)
        let captionHeight = vm.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight+300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}


extension TweetController: TweetHeaderDelegate{
    
   
    
    func showActionSheet() {
        if tweet.user.isCurrentUser{
            showActionSheet(forUser: tweet.user)
        }
        else{
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollow = isFollowed
                print("Debug -> \(isFollowed)")
                self.showActionSheet(forUser: user)
            }
        }
    }
    
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension TweetController: ActionSheetLauncherDelegate{
    func didSelect(option: ActionSheetOptions) {
        switch option{
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { error, ref in
                print("Debug -> Follow @\(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                print("Debug -> Unfollow \(user.username)")
            }
        case .report:
            print("Debug -> Report")
        case .delete:
            print("Debug -> Delete")
        }
    }
}
