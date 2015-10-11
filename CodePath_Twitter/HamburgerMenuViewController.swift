//
//  HamburgerMenuViewController.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 10/7/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class HamburgerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var hamburgerViewController: HamburgerViewController!
    var viewControllers: [UIViewController] = []
    var menuItems = ["Profile", "Home", "Mentions"]
    
    private var profileViewController: UIViewController!
    private var tweetsViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationController")
        
//        viewControllers.append(profileViewController)
        viewControllers.append(tweetsViewController)
        viewControllers.append(tweetsViewController)
        viewControllers.append(tweetsViewController)
        
        hamburgerViewController.contentViewController = tweetsViewController
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HamburgerMenuCell", forIndexPath: indexPath) as! HamburberMenuCell
        cell.menuLabel.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedMenuItem = menuItems[indexPath.row]
        switch selectedMenuItem {
        case "Profile":
            let nc = viewControllers[indexPath.row] as! UINavigationController
            let vc = nc.viewControllers[0] as! TweetsViewController
            nc.navigationItem.title = selectedMenuItem
            vc.timelineTitle = selectedMenuItem
            vc.refreshTimelineTweets()
            vc.user = User.currentUser
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        case "Home":
            let nc = viewControllers[indexPath.row] as! UINavigationController
            let vc = nc.viewControllers[0] as! TweetsViewController
            nc.navigationItem.title = selectedMenuItem
            vc.timelineTitle = selectedMenuItem
            vc.refreshTimelineTweets()
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        case "Mentions":
            let nc = viewControllers[indexPath.row] as! UINavigationController
            let vc = nc.viewControllers[0] as! TweetsViewController
            nc.navigationItem.title = selectedMenuItem
            vc.timelineTitle = selectedMenuItem
            vc.refreshTimelineTweets()
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        default:
            break
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
