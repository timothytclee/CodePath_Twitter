//
//  ProfileViewController.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 10/7/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: User?
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("profileVC user")
        print(user)
        print(user?.screenname)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.registerNib(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.registerNib(UINib(nibName: "MultiuseTweetCell", bundle: nil), forCellReuseIdentifier: "MultiuseTweetCell")
        
        if user == nil {
            user = User.currentUser
        }
        
        TwitterClient.sharedinstance.userTimelineWithParams(["screen_name": user!.screenname!]) { (tweets, error) -> () in
            if error == nil {
                self.tweets = tweets
                print("success loading user tweets")
            } else {
                print("error: \(error)")
            }
        }
        print(tweets)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
            cell.nameLabel.text = user?.name
            cell.screennameLabel.text = user?.screenname
            cell.profileImage.setImageWithURL(NSURL(string: (user?.profileImageUrl)!))
            cell.profileImage.layer.cornerRadius = 3
            cell.tweetCount.text = String((user?.tweets)!)
            cell.followersCount.text = String((user?.followers)!)
            cell.followingCount.text = String((user?.following)!)
            if user?.coverImageUrl == nil {
                } else {
                cell.backgroundImage.setImageWithURL(NSURL(string: (user?.coverImageUrl)!))
                }
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("MultiuseTweetCell", forIndexPath: indexPath) as! MultiuseTweetCell
            print("cell created")
            print(tweets)
            cell.tweet = tweets?[indexPath.row]
            return cell
        }
    }
}
