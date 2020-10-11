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
    
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            print("DEBUG: Api call completed twwets \(tweets)")
            self.tweets = tweets
        }
    }
    
    
    
    
    //MARK: - Properties
    private var tweets = [Tweet](){
        didSet{
            collectionView.reloadData()
        }
    }
}

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}



extension ProfileController: ProfileHeaderDelegate {
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrentUser{
            return
        }
        
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
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}
