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

class ViewPodcastTableViewController: UITableViewController {
    
    var podcast:NSMutableDictionary!
    var episodes = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
        getPodcastEpisodes()
        getPodcastImage()
    }
    
    func formatView() {
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == playEpisode {
            if let indexPath = sender as? NSIndexPath {
                let vc = segue.destinationViewController as! PlayEpisodeTableViewController
                vc.podcast = podcast
                vc.episode = episodes[indexPath.row]
            }
        }
    }

}

class PodcastHeaderCell: UITableViewCell {
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    
}