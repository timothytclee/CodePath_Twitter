//
//  Tweet.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 9/30/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeElapsed: String?
    var numberOfRetweets: Int?
    var numberOfFavorites: Int?
    var retweeted: Bool?
    var favorited: Bool?
    var tweetID: String?
    
    init(dictionary: NSDictionary) {
        super.init()
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        timeElapsed = self.formatTimeElapsed(createdAt!)
        numberOfRetweets = dictionary["retweet_count"] as? Int
        numberOfFavorites = dictionary["favorite_count"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        tweetID = dictionary["id_str"] as? String
        
    }
    
    func formatTimeElapsed(sinceDate: NSDate) -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        let interval = NSDate().timeIntervalSinceDate(sinceDate)
        return formatter.stringFromTimeInterval(interval)!
    }
    
    func favorite() {
        TwitterClient.sharedinstance.favoriteTweet(tweetID!)
        numberOfFavorites!++
        favorited = true
    }
    
    func retweet() {
        TwitterClient.sharedinstance.retweetTweet(tweetID!)
        numberOfRetweets!++
        retweeted = true
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
