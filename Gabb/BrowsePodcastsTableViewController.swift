//
//  BrowsePodcastsTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 5/3/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

let collectionHeader = "CollectionHeader"
private let viewPodcast = "ViewPodcast"

class BrowsePodcastsTableViewController: UITableViewController {
    
    var podcastCollections:[NSMutableDictionary]!
    
    var continueListeningOptions = [NSDictionary]()
    
    var navBarBackgroundImage:UIImage?
    var navBarShadowImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        navBarBackgroundImage = navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
        navBarShadowImage = navigationController?.navigationBar.shadowImage
        
//        getPodastImages()
        getRecentSessions()
        
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
    
    func getRecentSessions() {
        SessionService.getRecentSessions({(result) -> Void in
            if let sessions = result {
                self.enableContinueListeningForSessions(sessions)
            }
        })
    }
    
    // This is real hacky and we should just make the server do it instead...
    func enableContinueListeningForSessions(sessions: [NSDictionary]) {
        for session in sessions {
            let sessionJSON = JSON(session)
            let episode:NSDictionary = ["title": sessionJSON["title"].stringValue, "audio_url": sessionJSON["episode_url"].stringValue]
            PodcastService.getPodcast(sessionJSON["podcast_id"].intValue, completion: { (result) -> Void in
                if let result = result {
                    let podcastJSON = JSON(result)["podcast"]
                    let podcast:NSDictionary = ["podcast_id": podcastJSON["podcast_id"].intValue, "title": podcastJSON["title"].stringValue, "image_url": podcastJSON["image_url"].stringValue]
                    let listeningOption:NSDictionary = ["podcast": podcast, "episode": episode]
                    self.continueListeningOptions.append(listeningOption)
//                    self.collectionView?.reloadData()
                    print(self.continueListeningOptions)
                }
            })
        }
    }
    
    func addProfileButton() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "person"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(BrowsePodcastsCollectionViewController.viewProfile))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func addLogoutButton() {
        let rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .Done, target: self, action: #selector(BrowsePodcastsCollectionViewController.login))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        let continueListeningSection = continueListeningOptions.count > 0 ? 1 : 0
//        let popularSection = popular.count > 0 ? 1 : 0
//        return continueListeningSection + popularSection + categories.count
        return podcastCollections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(collectionHeader, forIndexPath: indexPath)
        let collection = JSON(podcastCollections[indexPath.section])
        cell.textLabel?.text = collection["title"].stringValue
        return cell
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
        }
    }


}
