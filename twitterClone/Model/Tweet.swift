//
//  Tweet.swift
//  twitterClone
//
//  Created by joao camargo on 13/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetId: String
    //let uid: String
    var likes: Int
    var timestamp: Date!
    let retweetCount: Int
    let user: User
    var didLike = false
    var replyingTo: String?
    var isReply: Bool { return replyingTo != nil }
    
    init(user: User,tweetId: String, dictionary: [String: Any]){
        self.tweetId = tweetId
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        //self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
    }
}
