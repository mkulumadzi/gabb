//
//  BrowsePodcastsTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 5/3/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

class BrowsePodcastsTableViewController: UITableViewController {
    
    var popular:[NSMutableDictionary]!
    var categories:[NSMutableDictionary]!
    
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
        let continueListeningSection = continueListeningOptions.count > 0 ? 1 : 0
        let popularSection = popular.count > 0 ? 1 : 0
        return continueListeningSection + popularSection + categories.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
