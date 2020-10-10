//
//  UserCell.swift
//  twitterClone
//
//  Created by joao camargo on 10/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
       
    //MARK: - Properties
    var user: User? {
        didSet {
            configure()
        }
    }
    
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40/2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Full name"
        return label
    }()
    
    
    
    //MARK: - LifeCycle
    private func configure(){
        guard let user = user else { return }
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        self.usernameLabel.text = user.username
        self.fullnameLabel.text = user.fullname
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //backgroundColor = .systemPurple
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

