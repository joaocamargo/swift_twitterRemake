//
//  AuthService.swift
//  twitterClone
//
//  Created by joao camargo on 03/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

import UIKit

struct AuthCredentials{
    let email: String
    let password: String
    let username: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void){
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    let values = ["email":credentials.email, "username":credentials.username,"fullname":credentials.fullname, "profileImageURL": profileImageUrl]
                    let ref = DB_REF.child("users").child(uid)
                    ref.updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
    }
    
}
