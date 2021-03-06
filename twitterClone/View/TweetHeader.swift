//
//  TweetHeader.swift
//  twitterClone
//
//  Created by joao camargo on 11/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

protocol TweetHeaderDelegate: class {
    func showActionSheet()
    func handleFetchUser(withUsername username: String)
}

class TweetHeader: UICollectionReusableView {
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: TweetHeaderDelegate?
    
    //MARK: - properties
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
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Peter"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Spider"
        
        return label
    }()
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.text = "caption Labelcaption Labelcaption Labelcaption Labelcaption Labelcaption Labelcaption Label"
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "22/10/2020 - 13h 30 min"
        return label
    }()
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.frame.size.height = 100
        label.padding = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 0)
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy  var retweetsLabel = UILabel()
    
    private lazy  var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        //view.backgroundColor = .twitterBlue
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel,likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
               
        return view
    }()
    
    private lazy var commentButton: UIButton = {
       let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
       let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
       let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
       let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - lifecycle
    override init(frame: CGRect){
        super.init(frame: frame)
        //backgroundColor = .red
        let labelStack = UIStackView(arrangedSubviews: [fullNameLabel,usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        imageCaptionStack.spacing = 12

        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.spacing = 8
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12,paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor,paddingTop: 20, paddingLeft: 16)//, height: 20)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor,right: rightAnchor,paddingTop: 12, height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton, shareButton])
        actionStack.spacing = 72
        //actionStack.distribution = .equalSpacing
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        //actionStack.anchor(bottom: bottomAnchor, paddingBottom: 12)
        actionStack.anchor(top: statsView.bottomAnchor,paddingTop: 12)
        
        configureMentionHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func configure(){
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        fullNameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        retweetsLabel.attributedText = viewModel.retweetAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
    
    //MARK: - selectors
    
    @objc func handleProfileImageTapped(){
        print("Go to user profile")
        
    }
    
    @objc func showActionSheet(){
        print("show sheet")
        delegate?.showActionSheet()
    }
    
    @objc func handleRetweetTapped(){
        
    }
    
    @objc func handleLikeTapped(){
        
    }
    
    @objc func handleCommentTapped(){
        
    }
    
    @objc func handleShareTapped(){
        
    }
    
    
    
    //MARK: - helpers
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.tintColor = .darkGray
        return button
    }
    
    func configureMentionHandler(){
        captionLabel.handleMentionTap { username in
            self.delegate?.handleFetchUser(withUsername: username)
            print("DEBUG: mention \(username)")
        }
    }
    
}
