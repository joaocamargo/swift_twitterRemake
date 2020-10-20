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
    
    func uploadTweet(caption: String,type: UploadTweetConfiguration, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        let values  = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970),"likes":0, "retweets":0,"caption":caption] as [String : Any]
        
        let ref = REF_TWEETS.childByAutoId()

        
        switch type {
        case .tweet:
            ref.updateChildValues(values) { (err,ref) in
                guard let tweetID = ref.key else { return }
                REF_USERS_TWEETS.child(uid).updateChildValues([tweetID:1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetId).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
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
    
    func fetchTweets(forUser User: User, completion: @escaping([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        print("DEBUG: fetchTweets of USER: \(User.uid)")
        
        REF_USERS_TWEETS.child(User.uid).observe(.childAdded) { (snapshot) in
        let tweetID = snapshot.key
            print("DEBUG: loading of tweet: \(tweetID)")

            self.fetchTweet(withTweetID: tweetID) { (tweet) in
                tweets.append(tweet)
                completion(tweets)
            }
            
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()

        REF_TWEET_REPLIES.child(tweet.tweetId).observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetId: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
        
    }
    
    
    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { (likeTweet) in
                var tweet = likeTweet
                tweet.didLike = true
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        REF_TWEETS.child(tweet.tweetId).child("likes").setValue(likes)
        
        if tweet.didLike {
            //unlike tweet from firebase
            REF_USER_LIKES.child(uid).child(tweet.tweetId).removeValue { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            //like tweet to database
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetId: 1]) { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
        
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(tweet.tweetId).observeSingleEvent(of:  .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetId: tweetID, dictionary: dictionary)
                print("DEBUG: RETORNANDO TWEET \(tweetID)")
                completion(tweet)
            }
        }
    }
    
}
