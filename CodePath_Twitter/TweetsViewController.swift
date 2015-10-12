//
//  TweetsViewController.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 9/30/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, MultiuseTweetCellDelegate {
    
    var user: User?
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    var timelineTitle: String? = "Home"

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = User.currentUser
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.registerNib(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.registerNib(UINib(nibName: "MultiuseTweetCell", bundle: nil), forCellReuseIdentifier: "MultiuseTweetCell")

        refreshTimelineTweets()

    }
    
    override func viewDidAppear(animated: Bool) {
        refreshTimelineTweets()
    }
    
    func refreshTimelineTweets() {
        self.navigationItem.title = timelineTitle
        if timelineTitle! == "Profile" {
            print(user!.screenname!)
            TwitterClient.sharedinstance.userTimelineWithParams(["screen_name":user!.screenname!]) { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        if timelineTitle! == "Home" {
            print("loading home timeline")
            TwitterClient.sharedinstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            }
        }
        if timelineTitle! == "Mentions" {
            TwitterClient.sharedinstance.mentionsTimelineWithParams(nil) { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MultiuseTweetCell", forIndexPath: indexPath) as! MultiuseTweetCell
        cell.tweet = tweets![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // unhighlight row after selection
        self.performSegueWithIdentifier("TweetDetailSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch timelineTitle! {
        case "Profile":
            return 185 as CGFloat
        default:
            return 0 as CGFloat
        }
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
    
    func multiuseTweetCell(multiuseTweetCell: MultiuseTweetCell, didTapProfileImage user: User) {
        print("tweetsVC got the tap event")
        self.user = user
//        self.timelineTitle = "Profile"
//        refreshTimelineTweets()
        self.performSegueWithIdentifier("ProfileViewSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
        case "TweetDetailSegue":
            let vc = segue.destinationViewController as! TweetDetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            vc.tweetDetails = tweets![indexPath!.row]
        
        case "ComposeTweetSegue":
            let navvc = segue.destinationViewController as! UINavigationController
            let vc = navvc.viewControllers.first as! ComposeViewController
            vc.delegate = self
            
        case "ProfileViewSegue":
            let vc = segue.destinationViewController as! ProfileViewController
            vc.user = user

        default:
            return
        }
    }
    
    func onRefresh() {
        refreshTimelineTweets()
    }

}
