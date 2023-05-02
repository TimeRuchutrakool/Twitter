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
    
    //MARK: - Life Cycle
    
    init(tweet:Tweet){
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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


