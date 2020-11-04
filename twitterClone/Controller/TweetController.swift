//
//  TweetController.swift
//  twitterClone
//
//  Created by joao camargo on 11/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit

private let reuseHeaderIdentifier = "TweetHeaderCell"
private let reuseCellIdentifier = "TweetHeaderCell"

class TweetController: UICollectionViewController{
    
    //MARK: - Properties
    private let tweet: Tweet
    
    private var actionSheet: ActionSheetLauncher!
    
    private var replies = [Tweet](){
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - LifeCycle
    
    init(tweet: Tweet){
        self.tweet = tweet
        //self.actionSheet = ActionSheetLauncher(user: tweet.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())

        // var layout = UICollectionViewFlowLayout()
       // layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
       // collectionView!.collectionViewLayout = layout
       
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
        TweetService.shared.fetchReplies(forTweet: tweet) { (replies) in
            self.replies = replies
        }
    }
    
    //MARK: - helpers
    
    
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
    }
    
    func showActionSheet(user: User){
        actionSheet = ActionSheetLauncher(user: user) // tweet.user)
        self.actionSheet.delegate = self
        self.actionSheet.show()
    }
    
}

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
}

//MARK: - uicollectionviewdelegateflowlayout

extension TweetController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width, font: UIFont.systemFont(ofSize: 20)).height
        print("HEIGHT: \(height) + 250 = \(height+250)")
        return CGSize(width: view.frame.width, height: height + 210)
        
        //return CGSize(width: view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        //header.delegate = self
        return header
    }
}

extension TweetController: TweetHeaderDelegate {
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { (user) in
            print(user.username)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showActionSheet() {
        
        if tweet.user.isCurrentUser {
            showActionSheet(user: tweet.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { (isFollowed) in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(user: user)
            }
        }
    }
}

extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        print("esse puto")
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                print("did unfollow \(user)")
            }
        case .unfollow(let user):
            UserService.shared.unFollowUser(uid: user.uid) { (error, ref) in
                print("did unfollow \(user)")
            }
        case .report:
            print("report")
        case .delete:
            print("delete")
        }
    }
}
