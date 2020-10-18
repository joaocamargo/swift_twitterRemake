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

protocol ActionSheetLauncherDelegate: class {
    func didSelect(option: ActionSheetOptions)
}

public class ActionSheetLauncher: NSObject{
    
    
    //MARK: - Properties
    
    private let user: User
    private let tableView =  UITableView()
    private var window: UIWindow?
    private lazy var viewModel = ActionSheetViewModel(user: user)
    weak var delegate: ActionSheetLauncherDelegate?
    private var tableViewHeight: CGFloat?
    
    private lazy var blackView: UIView = {
       let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        view.isUserInteractionEnabled = true
        let tap = UIGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50/2
        return view
    }()
    
    init(user: User){
        
        self.user = user
        print("DEBUG: 3 - Usuario está sendo seguido: \(user.isFollowed)")
        super.init()
        configureTableView()

    }
    
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else { return }
        self.window = window

        window.addSubview(blackView)
        blackView.frame = window.frame

        
        window.addSubview(tableView)
        let height = CGFloat(viewModel.option.count * 60) + 100
        self.tableViewHeight = height
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
    }
    
    func configureTableView(){
        //tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource  = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - selectors
    @objc func handleDismissal(){
        print("DEBUG: handleDismissal")
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }
    
    //MARK: - helpers
    func showTableView(_ shouldShow: Bool){
        guard let window = window else {return}
        guard let height = tableViewHeight else { return }
        let y = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    
}

//MARK: - table view datasource

extension ActionSheetLauncher: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.option.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.option[indexPath.row]
        return cell
    }
    
}

//MARK: - tablewviewdelegate

extension ActionSheetLauncher: UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.option[indexPath.row]
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.showTableView(false)
        }) { _ in
            self.delegate?.didSelect(option: option)
        }
        
        delegate?.didSelect(option: option)
        print("Selected option: \(option.description)")
        
    }
}
