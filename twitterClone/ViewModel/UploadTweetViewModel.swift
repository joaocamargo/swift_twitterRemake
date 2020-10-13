//
//  UploadTweetViewModel.swift
//  twitterClone
//
//  Created by joao camargo on 12/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}


struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration){
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "Whats happening?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "reply"
            placeholderText = "Tweet your Reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
        
    }
    
}
