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
    
    func fetchNotifications(){
        NotificationService.shared.fetchNotifications { (notifications) in
            self.notifications = notifications
        }
    }
    
    
    //MARK: - Lifecycle
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
            configureUI()
            fetchNotifications()
        }
        
        //MARK: - Helpers
        
        func configureUI(){
            view.backgroundColor = .white
            navigationItem.title = "Notifications"
            tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
            tableView.rowHeight = 60
            tableView.separatorStyle = .none
        }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        //cell.notificationLabel.text = notifications[indexPath.row].tweetID
        return cell
    }
}
