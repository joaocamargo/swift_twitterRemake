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
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm ﹒ dd/MM/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetAttributedString : NSAttributedString {
        return attributedText(withValue: tweet.retweetCount, text:  "Retweets")
    }
    
    var likesAttributedString : NSAttributedString {
        return attributedText(withValue: tweet.likes, text:  "Likes")

    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username) ∙ \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                                  .foregroundColor: UIColor.lightGray ]))
        
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage {
        return tweet.didLike ? UIImage(named: "like_filled")! : UIImage(named: "like")!
    }
    
    init(tweet: Tweet){
        self.tweet = tweet
        self.user = tweet.user
    }
    
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat, font: UIFont) -> CGSize {
        let measurementLbael = UILabel()
        measurementLbael.text = tweet.caption
        measurementLbael.font = font
        measurementLbael.numberOfLines = 0
        measurementLbael.lineBreakMode = .byWordWrapping
        measurementLbael.translatesAutoresizingMaskIntoConstraints = false
        measurementLbael.widthAnchor.constraint(equalToConstant: width).isActive = true
        let size = measurementLbael.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        //print("HEIGHT: SIZE: \(size)")
        return size
    }
    
}


extension UILabel {
    func getSize(constrainedWidth: CGFloat) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: constrainedWidth, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

