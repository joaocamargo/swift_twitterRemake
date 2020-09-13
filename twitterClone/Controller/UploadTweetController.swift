//
//  UploadTweetController.swift
//  twitterClone
//
//  Created by joao camargo on 11/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit

class UploadTweetController : UIViewController{
    
    private let user: User
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
       
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
    
    private let captionTextView = CaptionTextView()
     
    //private let
    
        
    // MARK: selector
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadTweet(){
        print("hahshs")
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    
    
    // MARK: LifeCycle
    init(user: User){
        self.user = user
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
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
       

        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        print("DEBUG: user is \(user.username)")
        

        
        
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
              
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
}
