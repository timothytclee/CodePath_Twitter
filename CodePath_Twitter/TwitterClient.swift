//
//  TwitterClient.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 9/29/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit


let twitterConsumerKey = "3TEdyLmDz96zkpB9EfrL6Nt9L"
let twitterConsumerSecret = "y8U7FufhOOh8oL0jLSLREsXrVKXhRpySkOFUbcbKBUcaCOOqXw"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    static let sharedinstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedinstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //                print("home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    
    func mentionsTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedinstance.GET("1.1/statuses/mentions_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //                print("mentions timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    
    func userTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedinstance.GET("1.1/statuses/user_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                print("user timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting user timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    // API call to send a tweet
    func postTweet(status: String) {
        let params = ["status": status]
        TwitterClient.sharedinstance.POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("Post Statuses/Update: \(status)")
            print("Response: \(response)")
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("error posting tweet")
        })
    }
    
    
    // API call to favorite a tweet
    func favoriteTweet(id: String) {
        let params = ["id": id]
        TwitterClient.sharedinstance.POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("Favoriting tweet: \(id)")
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error favoriting tweet")
        })
    }
    
    
    // API call to retweet a tweet
    func retweetTweet(id: String) {
        let params = ["id": id]
        TwitterClient.sharedinstance.POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("Retweeting tweet: \(id)")
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error retweeting tweet")
        })
    }
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        // Fetch request token and redirect to auth page
        TwitterClient.sharedinstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedinstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("successfully got access token")
            TwitterClient.sharedinstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedinstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //                print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting current user")
                self.loginCompletion?(user: nil, error: error)
            })
            

            
            }) { (error: NSError!) -> Void in
                print("failed to see access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
}
