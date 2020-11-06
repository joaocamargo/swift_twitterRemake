//
//  MainTabController.swift
//  twitterClone
//
//  Created by joao camargo on 31/08/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

enum ActionButtonConfiguration {
    case tweet
    case message
}

class MainTabController: UITabBarController {
       
    
    // MARK: - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
    var user: User? {
        didSet{
            print("User was set")
            guard let nav = viewControllers?[0] as? UINavigationController else { return}
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()

    //MARK: - API
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { (user) in
            self.user = user
            print(user.username)
        }
    }
    
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
            print("User is not logged in")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: true,completion: nil)
            }
            //perform
        }
        else{
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func signUserOut(){
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateUserAndConfigureUI()
        //signUserOut()
    }
    
    
    //MARK: - selectors
    
    @objc func handleActionButtonTapped(){
        
        let controller: UIViewController
        
        switch buttonConfig {
        case .tweet:
            guard let user = user else { return }
            controller = UploadTweetController(user: user, config: .tweet)
        case .message:
            controller = SearchController(config: .messages)
        }
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        view.addSubview(actionButton)
        
        self.delegate = self
        /*actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -64).isActive = true
        actionButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -16).isActive = true
        actionButton.layer.cornerRadius = 56/2 /**/*/
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56/2
    }
    

    
    func configureViewControllers(){
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navFeed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)

        let explore = SearchController(config: .userSearch)
        let navExplore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
       
        let notifications = NotificationsController()
        let navNotifications = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let navConversations = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        viewControllers = [navFeed,navExplore,navNotifications,navConversations]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
    
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        
        let image = index == 3 ?  #imageLiteral(resourceName: "mail") : #imageLiteral(resourceName: "new_tweet")
        self.actionButton.setImage(image, for: .normal)
        buttonConfig = index == 3 ? .message : .tweet
        print(index)
    }
}
