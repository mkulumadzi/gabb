//
//  MainViewController.swift
//  Gabb
//
//  Created by Evan Waters on 5/13/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainViewContainer: UIView!
    @IBOutlet weak var nowPlayingWidgetContainer: UIView!
    @IBOutlet weak var nowPlayingWidgetHeight: NSLayoutConstraint!
    
    var podcastGroups = [NSMutableDictionary]()
    
    var mainNavController:UINavigationController!
    var nowPlayingWidget:NowPlayingWidgetViewController!
    
    override func viewWillAppear(animated: Bool) {
        addMainNavController()
        addNowPlayingWidget()
        if gabber == nil {
            nowPlayingWidgetHeight.constant = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func addMainNavController() {
        if mainNavController == nil {
            if let nav = UIStoryboard(name: "Browse", bundle: nil).instantiateInitialViewController() as? UINavigationController {
                
                mainNavController = nav
                
                if let browseVc = nav.viewControllers.first as? BrowsePodcastsViewController {
                    browseVc.podcastGroups = self.podcastGroups
                }
                
                embedViewController(nav, intoView: mainViewContainer)
                
                let top = NSLayoutConstraint(item: nav.view, attribute: .Top, relatedBy: .Equal, toItem: mainViewContainer, attribute: .Top, multiplier: 1.0, constant: 0.0)
                let bottom = NSLayoutConstraint(item: nav.view, attribute: .Bottom, relatedBy: .Equal, toItem: mainViewContainer, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
                let leading = NSLayoutConstraint(item: nav.view, attribute: .Leading, relatedBy: .Equal, toItem: mainViewContainer, attribute: .Leading, multiplier: 1.0, constant: 0.0)
                let trailing = NSLayoutConstraint(item: nav.view, attribute: .Trailing, relatedBy: .Equal, toItem: mainViewContainer, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
                
                nav.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activateConstraints([top, bottom, leading, trailing])
                
            }
        }
    }
    
    func addNowPlayingWidget() {
        if nowPlayingWidget == nil {
             if let vc = fetchViewController("Browse", storyboardIdentifier: "nowPlayingWidget") as? NowPlayingWidgetViewController {
                
                nowPlayingWidget = vc
                embedViewController(vc, intoView: nowPlayingWidgetContainer)
                
                let top = NSLayoutConstraint(item: vc.view, attribute: .Top, relatedBy: .Equal, toItem: nowPlayingWidgetContainer, attribute: .Top, multiplier: 1.0, constant: 0.0)
                let height = NSLayoutConstraint(item: vc.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
                let leading = NSLayoutConstraint(item: vc.view, attribute: .Leading, relatedBy: .Equal, toItem: nowPlayingWidgetContainer, attribute: .Leading, multiplier: 1.0, constant: 0.0)
                let trailing = NSLayoutConstraint(item: vc.view, attribute: .Trailing, relatedBy: .Equal, toItem: nowPlayingWidgetContainer, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
                
                vc.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activateConstraints([top, height, leading, trailing])
                
            }
        }
    }
    
    func toggleNowPlayingWidget() {
        guard let gabber = gabber, nowPlayingWidget = nowPlayingWidget else {
            return
        }
        gabber.delegate = nowPlayingWidget
        nowPlayingWidget.formatView()
        showNowPlayingWidget()
    }
    
    func showNowPlayingWidget() {
        nowPlayingWidgetHeight.constant = 60
        weak var weakSelf = self
        UIView.animateWithDuration(0.5, animations: {
            weakSelf?.view.layoutIfNeeded()
        })
    }
    
    func hideNowPlayingWidget() {
        nowPlayingWidgetHeight.constant = 0
        weak var weakSelf = self
        UIView.animateWithDuration(0.5, animations: {
            weakSelf?.view.layoutIfNeeded()
        })
    }
    

}
