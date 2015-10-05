//
//  TweetsViewController.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 9/30/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate {
    
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        refreshTimelineTweets()
    }
    
    func refreshTimelineTweets() {
        TwitterClient.sharedinstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCellID", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // unhighlight row after selection
        self.performSegueWithIdentifier("TweetDetailSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

        default:
            return
        }
    }
    
    func onRefresh() {
        refreshTimelineTweets()
    }

}
