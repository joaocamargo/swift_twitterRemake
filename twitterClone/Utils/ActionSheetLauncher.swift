//
//  ActionSheetLauncher.swift
//  twitterClone
//
//  Created by joao camargo on 15/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "ActionSheetCell"

public class ActionSheetLauncher: NSObject{
    
    
    //MARK: - Properties
    
    private let user: User
    private let tableView =  UITableView()
    private var window: UIWindow?
    
    init(user: User){
        
        self.user = user
        super.init()
        configureTableView()

    }
    
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else { return }
        self.window = window
        
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height - 300, width: window.frame.width, height: 300)
    }
    
    func configureTableView(){
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource  = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
}

extension ActionSheetLauncher: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
}

extension ActionSheetLauncher: UITableViewDelegate{
    
}
