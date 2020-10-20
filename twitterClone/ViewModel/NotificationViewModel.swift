//
//  NotificationViewMoidel.swift
//  twitterClone
//
//  Created by joao camargo on 19/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit

struct NotificationViewModel {
    
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "pt-BR") //NSLocalized
        //let formatter = DateComponentsFormatter()
        return calendar
    }
    
    
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.calendar = self.calendar
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to:now) ?? ""
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.user = notification.user
        self.type = notification.type
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    
    var notificationMessage: String {
        switch type {
        case .follow: return " started following you"
        case .like: return " liked one of your tweets"
        case .reply: return " replied to your tweet"
        case .retweet: return " retweeted your tweet"
        case .mention: return " mentioned you in a tweet"
        }
    }
    
    var shouldHideFollowutton: Bool {
        return type != .follow
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil }
        let attributedText = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        
        attributedText.append(NSAttributedString(string: " \(timestamp)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        return attributedText
    }
    
}


