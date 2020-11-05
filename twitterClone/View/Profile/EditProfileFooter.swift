//
//  EditProfileFooter.swift
//  twitterClone
//
//  Created by joao camargo on 05/11/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit

protocol EditProfileFooterDelegate: class {
    func handleLogout()
}

class EditProfileFooter: UIView {
    
    //MARK: - properties
    
    weak var delegate: EditProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    //MARK: - lifecycle
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //logoutButton.addConstraintsToFillView(self)
        //logoutButton.setDimensions(width: frame.width - 32, height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - selectors
    
    @objc func handleLogout(){
        delegate?.handleLogout()
    }
}
