//
//  MultiuseTweetCell.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 10/8/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol MultiuseTweetCellDelegate {
    optional func multiuseTweetCell(multiuseTweetCell: MultiuseTweetCell, didTapProfileImage user: User)
    optional func multiuseTweetCell(multiuseTweetCell: MultiuseTweetCell, didTapReplyButton tweet: Tweet)
}

class MultiuseTweetCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!
    @IBOutlet weak var tweetContentsLabel: UILabel!
    @IBOutlet weak var tweetTimeElapsedLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: MultiuseTweetCellDelegate?
    
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
        self.delegate?.multiuseTweetCell?(self, didTapReplyButton: self.tweet!)
        print("delegate - tweet")
    }
    
//    @IBAction func onImageTap(sender: UITapGestureRecognizer) {
//        self.delegate?.multiuseTweetCell?(self, didTapProfileImage: self.tweet.user!)
//        print("delegate - user")
//    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userProfileImage.layer.cornerRadius = 3
        userProfileImage.clipsToBounds = true
        let imageTap = UITapGestureRecognizer(target: self, action: "onImageTap:")
//        imageTap.delegate = self
        userProfileImage.addGestureRecognizer(imageTap)
    }
    
    func onImageTap(recognizer: UITapGestureRecognizer) {
        print("imagetap")
        let user = self.tweet.user
        delegate?.multiuseTweetCell?(self, didTapProfileImage: user!)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

