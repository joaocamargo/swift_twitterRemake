//
//  UploadTweetController.swift
//  twitterClone
//
//  Created by joao camargo on 11/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel


class UploadTweetController : UIViewController{
    
    private let user: User
    
    private let config: UploadTweetConfiguration
    
    private lazy var viewModel = UploadTweetViewModel(config: config)
       
    // MARK: Properties
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tweet", for: .normal)
        button.backgroundColor = .twitterBlue
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .red
        return iv
    }()
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        label.text = "replying to someone"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = CaptionTextView()
     
    //private let
    
        
    // MARK: selector
    @objc func handleCancel(){
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadTweet(){
        print("hahshs")
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(toUser: tweet.user, type: .reply,tweetID: tweet.tweetId)
            }
            
            self.uploadMentionNotification(forCaption: caption, tweetID: ref.key)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        switch config {
        case .tweet:
            print("Config is tweet")
        case .reply(let tweet):
            print("Config is reply of: \(tweet.caption)")
        }
        
        configureMentionHandler()
        
    }
    
    init(user: User, config: UploadTweetConfiguration){
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: API
    
    
    
    // MARK: HELPERS
    
    func configureUI(){
        view.backgroundColor = .white
        configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageCaptionStack])
        stack.axis = .vertical
        //stack.alignment = .leading
        stack.spacing = 12
        
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
       

        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        print("DEBUG: user is \(user.username)")
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholder.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
              
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func configureMentionHandler(){    
        replyLabel.handleMentionTap { (mention) in
            print("DEBUG: mentioned user is \(mention)")
        }
    }
    
    fileprivate func uploadMentionNotification(forCaption caption: String,
                                                tweetID: String?) {
        guard caption.contains("@") else { return }
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
     
        words.forEach { word in
            guard word.hasPrefix("@") else { return }
     
            var username = word.trimmingCharacters(in: .symbols)
            username = username.trimmingCharacters(in: .punctuationCharacters)
     
            UserService.shared.fetchUser(withUsername: username) { mentionedUser in
                NotificationService.shared.uploadNotification(toUser: mentionedUser,type: .mention,tweetID: tweetID)
            }
        }
    }
    
}

