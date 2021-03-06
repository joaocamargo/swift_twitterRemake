//
//  TweetService.swift
//  twitterClone
//
//  Created by joao camargo on 25/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    
    func uploadTweet(caption: String, completion: @escaping(Error?,DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid":uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes":0,
                      "retweets":0,
        "caption":caption ] as [String:Any]
        
    }
    
    
}
