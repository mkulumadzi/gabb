//
//  BrowsePodcastsTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 5/3/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

private let groupHeader = "GroupHeader"
private let podcastCollectionCell = "PodcastCollectionCell"
private let viewPodcast = "ViewPodcast"
private let viewPodcastGroup = "ViewPodcastGroup"

class BrowsePodcastsTableViewController: UITableViewController {
    
    var podcastGroups:[NSMutableDictionary]!
    
    var continueListeningOptions = [NSDictionary]()
    
    var navBarBackgroundImage:UIImage?
    var navBarShadowImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        navBarBackgroundImage = navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
        navBarShadowImage = navigationController?.navigationBar.shadowImage
        
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        getPodastImages()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        formatView()
        if let _ = currentUser {
            addProfileButton()
        }
        else {
            addLogoutButton()
        }
    }
    
    func formatView() {
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.logoSmall(), NSForegroundColorAttributeName : UIColor.gabbRedColor()]
        navigationItem.title = "Gabb"
        
        navigationController?.navigationBar.tintColor = UIColor.gabbRedColor()
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.translucent = false
        if let backgroundImage = navBarBackgroundImage {
            navigationController?.navigationBar.setBackgroundImage(backgroundImage, forBarMetrics: .Default)
        }
        if let shadowImage = navBarShadowImage {
            navigationController?.navigationBar.shadowImage = shadowImage
        }
    }
    
    func addProfileButton() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "person"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(self.viewProfile))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func addLogoutButton() {
        let rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .Done, target: self, action: #selector(BrowsePodcastsCollectionViewController.login))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }


    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return podcastGroups.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.tableView(tableView, headerCellForIndexPath: indexPath)
        } else {
            return self.tableView(tableView, podcastCollectionCellForIndexPath: indexPath)
        }
    }
    
    func tableView(tableVeiw: UITableView, headerCellForIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(groupHeader, forIndexPath: indexPath)
        let group = JSON(podcastGroups[indexPath.section])
        cell.textLabel?.text = group["title"].stringValue
        return cell
    }
    
    func tableView(tableVeiw: UITableView, podcastCollectionCellForIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(podcastCollectionCell, forIndexPath: indexPath) as! PodcastCollectionTableViewCell
        let group = JSON(podcastGroups[indexPath.section])
        cell.podcastGroup = group
        cell.podcastCollectionView.delegate = cell
        cell.podcastCollectionView.dataSource = cell
        cell.podcastCollectionViewHeight.constant = thumbnailSize.height + 34 // Clean this up
        if cell.shouldGetPodcasts == true {
            cell.shouldGetPodcasts = false
            cell.getPodcasts()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let podcastCollection = podcastGroups[indexPath.section]
            self.performSegueWithIdentifier(viewPodcastGroup, sender: podcastCollection)
        }
    }
    
    // MARK: - User actions
    
    func viewProfile() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func login() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            presentViewController(vc, animated: true, completion: nil)
        }
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == viewPodcast {
            if let vc = segue.destinationViewController as? ViewPodcastTableViewController {
                if let cell = sender as? PodcastCollectionViewCell {
                    vc.podcast = cell.podcast
                }
            }
        } else if segue.identifier == viewPodcastGroup {
            if let vc = segue.destinationViewController as? PodcastGroupCollectionViewController {
                if let group = sender as? NSMutableDictionary {
                    vc.podcastGroup = group
                }
            }
        }
    }


}
