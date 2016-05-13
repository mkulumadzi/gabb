//
//  ViewPodcastTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/27/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

private let podcastHeaderCell = "PodcastHeader"
private let podcastEpisodeCell = "PodcastEpisode"
private let playEpisode = "PlayEpisode"
private let viewChat = "ViewChat"
private let login = "Login"

class ViewPodcastTableViewController: UITableViewController {
    
    var podcast:NSMutableDictionary!
    var episodes = [NSDictionary]()
    
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
        
        getPodcastEpisodes()
        getPodcastImage()
    }
    
    override func viewDidAppear(animated: Bool) {
        formatView()
        tableView.reloadData()
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
    
    func getPodcastEpisodes() {
        if let podcast_id = podcast.valueForKey("podcast_id") as? NSInteger {
            PodcastService.getEpisodesForPodcast(podcast_id, completion: {(episodeArray) -> Void in
                if let episodeArray = episodeArray {
                    self.episodes = episodeArray
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func getPodcastImage() {
        if let imageURL = podcast.valueForKey("image_url") as? String {
            FileService.getFullImageForURL(imageURL, completion: {(image) -> Void in
                if let image = image {
                    self.podcast.setValue(image, forKey: "image")
                    self.tableView.reloadData()
                }
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(podcastHeaderCell) as! PodcastHeaderCell
        if let image = podcast["image"] as? UIImage {
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
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        guard let gabber = gabber else {
//            return nil
//        }
//        if gabber.playing {
//            let widgetContainer = UIView(frame: CGRectMake(0, 0, screenSize.width, 60))
//            widgetContainer.backgroundColor = UIColor.lightGrayColor()
//            
//            if let widget = fetchViewController("Browse", storyboardIdentifier: "nowPlayingWidget") as? NowPlayingWidgetViewController {
//                widget.view.frame = CGRectMake(0,0, screenSize.width, 60)
//                gabber.delegate = widget
//                self.embedViewController(widget, intoView: widgetContainer)
//            }
//            
//            return widgetContainer
//        }
//        else {
//            return nil
//        }
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(podcastEpisodeCell, forIndexPath: indexPath)
        let episode = episodes[indexPath.row]
        if let episodeTitle = episode.valueForKey("title") as? String {
            cell.textLabel?.text = episodeTitle
            cell.textLabel?.numberOfLines = 0
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
        }
    }

}

class PodcastHeaderCell: UITableViewCell {
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    
}