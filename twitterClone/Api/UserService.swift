//
//  UserService.swift
//  twitterClone
//
//  Created by joao camargo on 03/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference)-> Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User)->Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : AnyObject] else {return}
            
            guard let username = dictionary["username"] as? String else {return}
            print(username)
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUser(completion: @escaping([User])->Void){
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USERS_FOLLOWING.child(currentUid).updateChildValues([uid:1]) { (err, ref) in
            REF_USERS_FOLLOWERS.child(uid).updateChildValues([currentUid:1], withCompletionBlock: completion)
        }
    }
    
    func unFollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USERS_FOLLOWING.child(currentUid).child(uid).removeValue { (error, ref) in
            REF_USERS_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        REF_USERS_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { (snap) in
            completion(snap.exists())
        }
    }
    
}
