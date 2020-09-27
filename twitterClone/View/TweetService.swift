//
//  TweetService.swift
//  twitterClone
//
//  Created by joao camargo on 12/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        let values  = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970),"likes":0, "retweets":0,"caption":caption] as [String : Any]
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded){ snapshot in
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetId: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
            
        }
    }
    
    
}
