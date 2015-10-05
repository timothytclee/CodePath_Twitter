//
//  TweetCell.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 9/30/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!
    @IBOutlet weak var tweetContentsLabel: UILabel!
    @IBOutlet weak var tweetTimeElapsedLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            userNameLabel.text = tweet.user?.name
            userScreennameLabel.text = "@\((tweet.user?.screenname)!)"
            tweetContentsLabel.text = tweet.text
            tweetTimeElapsedLabel.text = tweet.timeElapsed
            userProfileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!))
            if (tweet.favorited == true) {
                favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
            }
            if (tweet.retweeted == true) {
                retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
            }

        }
    }
    @IBAction func favoriteButtonTap(sender: AnyObject) {
        tweet.favorite()
        favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        print("favorited tweet")
    }
    

    @IBAction func retweetButtonTap(sender: AnyObject) {
        tweet.retweet()
        retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        print("retweeted tweet")
    }
    
    @IBAction func replyButtonTap(sender: AnyObject) {

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userProfileImage.layer.cornerRadius = 3
        userProfileImage.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
