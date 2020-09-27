//
//  UserService.swift
//  twitterClone
//
//  Created by joao camargo on 03/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import Firebase

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
}
