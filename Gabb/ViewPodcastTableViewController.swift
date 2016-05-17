//
//  ViewPodcastTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/27/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

private let podcastHeaderCell = "PodcastHeader"
private let podcastEpisodeCell = "PodcastEpisode"
private let playEpisode = "PlayEpisode"
private let podcastSummaryCell = "SummaryCell"
private let viewChat = "ViewChat"
private let login = "Login"

class ViewPodcastTableViewController: UITableViewController {
    
    var podcast:NSMutableDictionary!
    var episodes = [NSDictionary]()
    var podcastImage:UIImage!
    
    // Using this so that we have some chats to send in the segue...
    var chats:[NSDictionary]!
    
    var navBarBackgroundImage:UIImage?
    var navBarShadowImage:UIImage?

    @IBOutlet weak var chatButton: UIButton!
    
    override func viewDidLoad() {
        formatImages()
        super.viewDidLoad()
        
        navBarBackgroundImage = navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
        navBarShadowImage = navigationController?.navigationBar.shadowImage
        getPodcastImage()
    }
    
    override func viewDidAppear(animated: Bool) {
        getPodcastDetails()
        formatView()
    }
    
    func formatImages() {
        if let image = UIImage(named: "chat")?.imageWithRenderingMode(.AlwaysTemplate) {
            chatButton.setImage(image, forState: .Normal)
        }
    }
    
    func formatView() {
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
    
    // MARK: - Downloading podcast episodes
    
    func getPodcastDetails() {
        weak var weakSelf = self
        if let podcast_id = podcast.valueForKey("podcast_id") as? NSInteger {
            PodcastService.getPodcastDetails(podcast_id, completion: {(result) -> Void in
                if let podcast = result {
                    weakSelf?.podcast = podcast
                    if let episodeArray = podcast.valueForKey("recent_episodes") as? [NSDictionary] {
                        weakSelf?.episodes = episodeArray
                    }
                }
                weakSelf?.tableView.reloadData()
            })
        }
    }
    
    func getPodcastImage() {
        weak var weakSelf = self
        if let imageURL = podcast.valueForKey("image_url") as? String {
            FileService.getFullImageForURL(imageURL, completion: {(image) -> Void in
                if let image = image {
                    weakSelf?.podcastImage = image
                    self.tableView.reloadData()
                }
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let _ = podcast["summary"] as? String {
                return 1
            } else {
                return 0
            }
        case 1:
            return episodes.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 120.0
        case 1:
            return 20.0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(podcastHeaderCell) as! PodcastHeaderCell
            if let image = podcastImage {
                cell.podcastImageView.image = image
            }
            if let podcastTitle = podcast["title"] as? String {
                cell.podcastTitleLabel.text = podcastTitle
                cell.podcastTitleLabel.backgroundColor = UIColor.gabbBlackColor()
                cell.podcastTitleLabel.textColor = UIColor.whiteColor()
                cell.podcastTitleLabel.font = UIFont.systemFontOfSize(24.0)
                cell.podcastTitleLabel.alpha = 0.8
            }
            else {
                cell.podcastTitleLabel.text = ""
            }
            return cell
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        default:
            return "Episodes"
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return summaryCell(tableView, atIndexPath: indexPath)
        default:
            return episodeCell(tableView, atIndexPath: indexPath)
        }
        
    }
    
    func summaryCell(tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(podcastSummaryCell, forIndexPath: indexPath)
        if let summary = podcast["summary"] as? String {
            cell.textLabel?.text = summary
            cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
    
    func episodeCell(tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(podcastEpisodeCell, forIndexPath: indexPath)
        let episode = episodes[indexPath.row]
        if let episodeTitle = episode.valueForKey("title") as? String {
            cell.textLabel?.text = episodeTitle
            cell.textLabel?.numberOfLines = 0
        }
        
        if let session = episode["last_session"] as? NSDictionary {
            let json = JSON(session)
            if json["finished"].boolValue == true {
                if let image = UIImage(named: "empty") {
                    cell.imageView?.image = image.imageWithRenderingMode(.AlwaysTemplate)
                    cell.imageView?.tintColor = UIColor.gabbDarkGreyColor()
                }
            } else {
                if let image = UIImage(named: "half-full") {
                    cell.imageView?.image = image.imageWithRenderingMode(.AlwaysTemplate)
                    cell.imageView?.tintColor = UIColor.gabbDarkGreyColor()
                }
            }
        } else {
            if let image = UIImage(named: "full") {
                cell.imageView?.image = image.imageWithRenderingMode(.AlwaysTemplate)
                cell.imageView?.tintColor = UIColor.gabbDarkGreyColor()
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(playEpisode, sender: indexPath)
    }
    
    // MARK: User Actions
    
    @IBAction func chatButtonTapped(sender: AnyObject) {
        if let _ = currentUser {
            chatButton.enabled = false
            ChatService.getChatsForPodcast(self.podcast, completion: {(result) -> Void in
                if let chats = result {
                    self.chats = chats
                } else {
                    self.chats = [NSDictionary]()
                }
                self.chatButton.enabled = true
                self.performSegueWithIdentifier(viewChat, sender: self)
            })
        }
        else {
            performSegueWithIdentifier(login, sender: self)
        }
    }
    
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == playEpisode {
            if let indexPath = sender as? NSIndexPath {
                let vc = segue.destinationViewController as! PlayEpisodeViewController
                vc.podcast = podcast
                vc.episode = episodes[indexPath.row]
            }
        }
        else if segue.identifier == viewChat {
            let chatController = segue.destinationViewController as! GabbChatViewController
            chatController.dataSource = GabbChatDataSource(podcast: self.podcast, chats: chats)
            chatController.messageSender = chatController.dataSource.messageSender
            
            if let title = podcast["title"] as? String {
                chatController.navigationItem.title = title
            }
        }
    }

}

class PodcastHeaderCell: UITableViewCell {
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    
}