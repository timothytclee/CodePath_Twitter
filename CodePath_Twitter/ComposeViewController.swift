//
//  ComposeViewController.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 10/3/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
    optional func composeViewController(composeViewController: ComposeViewController, didChangeValue value: Bool)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    var tweetDetails: Tweet!
    
    weak var delegate: ComposeViewControllerDelegate?

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!
    @IBOutlet weak var tweetComposeTextView: UITextView!
    @IBOutlet weak var countdownBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.setImageWithURL(NSURL(string: (User.currentUser?.profileImageUrl)!))
        userProfileImage.layer.cornerRadius = 3
        userProfileImage.clipsToBounds = true
        userNameLabel.text = User.currentUser?.name
        userScreennameLabel.text = User.currentUser?.screenname
        countdownBarButton.title = "140"
        tweetComposeTextView.textColor = UIColor.grayColor()
        tweetComposeTextView.text = "Update your status here"
//        tweetComposeTextView.becomeFirstResponder()
        tweetComposeTextView.delegate = self
    }

    
    @IBAction func cancelBarButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tweetBarButton(sender: AnyObject) {
        TwitterClient.sharedinstance.postTweet(tweetComposeTextView.text)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(tweetComposeTextView: UITextView) {
        tweetComposeTextView.text = ""
    }
    
    func textViewDidChange(textView: UITextView) {
        var characterCount = (tweetComposeTextView.text).characters.count
        var remainingCharacters = max(0, 140 - characterCount)
        countdownBarButton.title = "\(remainingCharacters)"
    }



}
