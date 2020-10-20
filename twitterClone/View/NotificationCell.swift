//
//  NotificationCell.swift
//  twitterClone
//
//  Created by joao camargo on 18/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit


protocol NotificationCellDelegate: class {
    func didTapProfileImage(_ cell: NotificationCell)
    func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {

//MARK: - properties
    
    weak var delegate: NotificationCellDelegate?
    
    var notification: Notification? {
        didSet {
            configure()
        }
    }

    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .red
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.addTarget(self, action: #selector(hangleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Exemplo de notificação"
        return label
    }()
    
    
//MARK: - lifecycle
    
//MARK: - ojb funcs
    
    @objc func handleProfileImageTapped() {
        print("DEBUG: handleProfileImageTapped -  didTapProfileImage")
        delegate?.didTapProfileImage(self)
    }
    
    @objc func hangleFollowTapped(){
        print("hangleFollowTapped")
        delegate?.didTapFollow(self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        contentView.addSubview(stack)
        //stack.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12) //rever video 80 finalzinho se tiver errado
        stack.anchor(left: leftAnchor, right: rightAnchor,paddingLeft: 12, paddingRight: 12)
        
        let stackFollow = UIStackView(arrangedSubviews: [stack,followButton])
        
        contentView.addSubview(stackFollow)
        stackFollow.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        stackFollow.spacing = 0
        stackFollow.alignment = .center
        
        
        
        //addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 80, height: 32)
        followButton.layer.cornerRadius = 32/2
        followButton.anchor(right: rightAnchor,paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - helpers
    
    func configure() {
        guard let notification = notification else { return }
        let viewModel =  NotificationViewModel(notification: notification)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        
        followButton.isHidden = viewModel.shouldHideFollowutton
        
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        
    }
    

}



