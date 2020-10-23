//
//  EditProfileController.swift
//  twitterClone
//
//  Created by joao camargo on 23/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit


class EditProfileController: UITableViewController {
    
    //MARK: - properties
    private let user: User
    private lazy var headerView = EditProfileHeader(user: user)
    
    //MARK: - lifecycle
    
    init(user: User){
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
    }
    
    //MARK: - selectors
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - api
    
    
    //MARK: - helpers
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configureTableView(){
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()
        headerView.delegate = self
    }
    
}

extension EditProfileController: EditProfileHeaderDelegate{
    func didTapChangeProfilePhoto() {
        <#code#>
    }
    
    
}
