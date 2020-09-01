//
//  NotificationsController.swift
//  twitterClone
//
//  Created by joao camargo on 31/08/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit


class NotificationsController: UIViewController{
    // MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
            configureUI()
        }
        
        //MARK: - Helpers
        
        func configureUI(){
            view.backgroundColor = .white
            navigationItem.title = "Notifications"
        }
}
