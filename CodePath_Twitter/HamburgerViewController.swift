//
//  HamburgerViewController.swift
//  CodePath_Twitter
//
//  Created by Timothy Lee on 10/7/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {


    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLeftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat = 0.0
    var hamburgerMenuViewController: UIViewController! {
        didSet(oldHamburgerMenuViewController) {
            view.layoutIfNeeded()
            if oldHamburgerMenuViewController != nil {
                oldHamburgerMenuViewController.willMoveToParentViewController(nil)
                oldHamburgerMenuViewController.view.removeFromSuperview()
                oldHamburgerMenuViewController.didMoveToParentViewController(nil)
            }
            hamburgerMenuViewController.willMoveToParentViewController(self)
            menuView.addSubview(hamburgerMenuViewController.view)
            hamburgerMenuViewController.didMoveToParentViewController(self)
        }
    }
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.contentViewLeftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
                }, completion: { (Bool) -> Void in
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func rotated() {
        UIView.animateWithDuration(0.5, animations: {
            self.contentViewLeftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = contentViewLeftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            contentViewLeftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                if velocity.x > 0 {
                    self.contentViewLeftMarginConstraint.constant = self.view.frame.size.width - 50
                } else {
                    self.contentViewLeftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
                }, completion: { (Bool) -> Void in
                    
            })
            
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
