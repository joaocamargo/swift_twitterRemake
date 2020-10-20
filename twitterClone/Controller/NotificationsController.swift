//
//  NotificationsController.swift
//  twitterClone
//
//  Created by joao camargo on 31/08/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit

private var reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    // MARK: - Properties
    
    private var notifications  = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    //MARK: - api
    
    fileprivate func checkIfUserFollowed(_ notifications: [Notification]) {
        for (index,notification) in notifications.enumerated() {
            if case .follow = notification.type{
                let user = notification.user
                UserService.shared.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
    func fetchNotifications(){
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { (notifications) in
            self.notifications = notifications
            self.checkIfUserFollowed(notifications)
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    //MARK: - Lifecycle
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .white
            configureUI()
            //fetchNotifications()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotifications()
    }
        
        //MARK: - Helpers
        
        func configureUI(){
            view.backgroundColor = .white
            navigationItem.title = "Notifications"
            tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
            tableView.rowHeight = 60
            tableView.separatorStyle = .none
            tableView.contentInset.top = 10
            
            let refreshControl = UIRefreshControl()
            tableView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            
        }
    
    //MARK: - selectors
    
    @objc func handleRefresh(){
        fetchNotifications()
        
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else { return }
        
        TweetService.shared.fetchTweet(withTweetID: tweetID) { (tweet) in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        //cell.notificationLabel.text = notifications[indexPath.row].tweetID
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension NotificationsController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        print("DEBUG: handlefollow tap")
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed{
            UserService.shared.unFollowUser(uid: user.uid) { (error, ref) in
                print("did unfollow \(user)")
                cell.notification?.user.isFollowed = false
            }
        }else{
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                print("did unfollow \(user)")
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}



