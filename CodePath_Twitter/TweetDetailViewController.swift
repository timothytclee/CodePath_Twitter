//
//  TweetDetailViewController.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 10/2/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweetDetails: Tweet!

    @IBOutlet var tweetView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScrennameLabel: UILabel!
    @IBOutlet weak var tweetContentsLabel: UILabel!
    @IBOutlet weak var tweetDateTimeLabel: UILabel!
    @IBOutlet weak var numberOfRetweetsLabel: UILabel!
    @IBOutlet weak var numberOfFavorites: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = tweetDetails.user?.name
        userScrennameLabel.text = "@\(tweetDetails.user?.screenname)"
        tweetContentsLabel.text = tweetDetails.text

        userProfileImage.setImageWithURL(NSURL(string: (tweetDetails.user?.profileImageUrl)!))
        userProfileImage.layer.cornerRadius = 3
        userProfileImage.clipsToBounds = true
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm aaa"
        tweetDateTimeLabel.text = formatter.stringFromDate(tweetDetails.createdAt!)
        
        refreshData()

    }
    
    func refreshData() {
        numberOfRetweetsLabel.text = "\(tweetDetails.numberOfRetweets!)"
        numberOfFavorites.text = "\(tweetDetails.numberOfFavorites!)"
        
        if (tweetDetails.favorited == true) {
            favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        }
        if (tweetDetails.retweeted == true) {
            retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        }
        
        print(tweetDetails)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteButtonTap(sender: UIButton) {
        tweetDetails.favorite()
        favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        print("favorited tweet")
        refreshData()
    }

    @IBAction func retweetButtonTap(sender: AnyObject) {
        tweetDetails.retweet()
        retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        print("retweeted tweet")
        refreshData()
    }
    
    @IBAction func replyButtonTap(sender: UIButton) {
    }


}
