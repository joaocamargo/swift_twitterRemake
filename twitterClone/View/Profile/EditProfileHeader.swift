//
//  EditProfileHeader.swift
//  twitterClone
//
//  Created by joao camargo on 23/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit

protocol EditProfileHeaderDelegate: class {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    
    //MARK: -  properties
    private var user:User
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3.0
        return iv
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change ", for: .normal)
        button.addTarget(self, action: #selector(handleChangerofilePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: - lifecycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .twitterBlue
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100/2
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - selector
    @objc func handleChangerofilePhoto(){
        delegate?.didTapChangeProfilePhoto()
    }
}
        
