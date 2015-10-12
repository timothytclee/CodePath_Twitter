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
        
        self.navigationItem.title == "Profile"
        
        if user == nil {
            user = User.currentUser
        }
        
        TwitterClient.sharedinstance.userTimelineWithParams(["screen_name":user!.screenname!]) { (tweets, error) -> () in
            if error == nil {
                self.tweets = tweets
                print("success loading user tweets")
            } else {
                print("error: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 185 as CGFloat
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileCell
        headerCell.nameLabel.text = user?.name
        headerCell.screennameLabel.text = "@\((user?.screenname)!)"
        headerCell.profileImage.setImageWithURL(NSURL(string: (user?.profileImageUrl)!))
        headerCell.profileImage.layer.cornerRadius = 3
        headerCell.tweetCount.text = String((user?.tweets)!)
        headerCell.followersCount.text = String((user?.followers)!)
        headerCell.followingCount.text = String((user?.following)!)
        if user?.coverImageUrl == nil {
        } else {
            headerCell.backgroundImage.setImageWithURL(NSURL(string: (user?.coverImageUrl)!))
        }
        return headerCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tweets != nil {
                print(tweets!.count)
                return tweets!.count
            } else {
                return 0
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("MultiuseTweetCell", forIndexPath: indexPath) as! MultiuseTweetCell
            print("cell created")
            print(tweets)
            cell.tweet = tweets?[indexPath.row]
            return cell
    }
}
