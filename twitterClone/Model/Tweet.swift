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
    let uid: String
    let likes: Int
    var timestamp: Date!
    let retweetCount: Int
    
    init(tweetId: String, dictionary: [String: Any]){
        self.tweetId = tweetId
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}