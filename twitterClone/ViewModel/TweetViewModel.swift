//
//  TweetViewModel.swift
//  twitterClone
//
//  Created by joao camargo on 27/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//
import UIKit
import Foundation

struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL? {
        return tweet.user.profileImageUrl
    }
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "pt-BR") //NSLocalized
        //let formatter = DateComponentsFormatter()
        return calendar
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.calendar = self.calendar
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to:now) ?? ""
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username) ∙ \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                                  .foregroundColor: UIColor.lightGray ]))
        
        return title
    }
    
    init(tweet: Tweet){
        self.tweet = tweet
        self.user = tweet.user
    }
    
}
