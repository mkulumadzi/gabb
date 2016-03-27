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

class ViewPodcastTableViewController: UITableViewController {
    
    var podcast:NSMutableDictionary!
    var episodes = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
        getPodcastEpisodes()
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        default:
            return episodes.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
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
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(podcastEpisodeCell, forIndexPath: indexPath)
            let episode = episodes[indexPath.row]
            if let episodeTitle = episode.valueForKey("title") as? String {
                cell.textLabel?.text = episodeTitle
            }
            return cell
        }
    }

}

class PodcastHeaderCell: UITableViewCell {
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    
}