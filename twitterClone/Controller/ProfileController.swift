//
//  ProfileController.swift
//  twitterClone
//
//  Created by joao camargo on 27/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "TweetCell"
private let reuseHeaderIdentifier = "ProfileHeader"


class ProfileController: UICollectionViewController {
    
    
    //MARK: - Properties
    private var user: User
    
    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var tweets = [Tweet]() /*{
        didSet {
            collectionView.reloadData()
        }
    }*/
    
    private var shouldNotShowReply = true
    
    private var likedTweets = [Tweet]()
    
    private var replies = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets:
            shouldNotShowReply = true
            return tweets
        case .replies:
            shouldNotShowReply = false
            return replies
        case .likes:
            shouldNotShowReply = true
            return likedTweets
        }
    }
    
    
    
    //MARK: - LifeCycle
    
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight + 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed();
        fetchUsersStats()
        fetchLikeTweets()
        fetchReplies()
    }
    
    func checkIfUserIsFollowed(){
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { (isFollowing) in
            self.user.isFollowed = isFollowing
            self.collectionView.reloadData()            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: - API
    
    func fetchLikeTweets(){
        TweetService.shared.fetchLikes(forUser: user) { (tweets) in
            self.likedTweets = tweets
        }
    }
    
    func fetchTweets() {
        print("DEBUG: Api call completed user: \(user.email)")
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            print("DEBUG: Api call completed tweets \(tweets.description)")
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func fetchUsersStats() {
        UserService.shared.fetchUsersStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
            //print("DEBUG: Api call completed twwets \(tweets)")
            //self.tweets = tweets
        }
    }
    
    func fetchReplies(){
        TweetService.shared.fetchReplies(forUser: user) { (tweets) in
            self.replies = tweets
            
            self.replies.forEach { reply in
                
            }
        }
    }
    
    
    //MARK: - Properties
}

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell        
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
    
    
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tweet = currentDataSource[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        var height = viewModel.size(forWidth: view.frame.width, font: UIFont.systemFont(ofSize: 14)).height + 88
        
        if currentDataSource[indexPath.row].isReply {
            height += 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
}

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: currentDataSource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        print("Debug did select filter \(filter.description)")
        self.selectedFilter = filter
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrentUser{
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            return
        } else {
            
            if self.user.isFollowed {
                UserService.shared.unFollowUser(uid: self.user.uid) { (error, ref) in
                    if let erro = error {
                        print("ERRO \(erro.localizedDescription)")
                    }
                    
                    self.user.isFollowed = false
                    header.editProfileFollowButton.setTitle("Follow", for: .normal)
                    self.collectionView.reloadData()
                    
                }
            } else {
                UserService.shared.followUser(uid: self.user.uid) { (error, ref) in
                    if let erro = error {
                        print("ERRO \(erro.localizedDescription)")
                    }
                    header.editProfileFollowButton.setTitle("Following", for: .normal)
                    self.user.isFollowed = true
                    NotificationService.shared.uploadNotification(type: .follow, user: self.user)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - editprofilecontrollerdelegate

extension ProfileController: EditProfileControllerDelegate{
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil )
        self.user = user
        self.collectionView.reloadData()
    }
}
