//
//  PodcastSearchResultsTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 5/6/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

private let searchResult = "SearchResult"

protocol PodcastSearchResultsDelegate {
    func podcastSelectedFromSearchResults(vc: PodcastSearchResultsTableViewController)
}

class PodcastSearchResultsTableViewController: UITableViewController {
    
    var podcasts = [NSMutableDictionary]()
    var podcastSelected:NSMutableDictionary!
    
    var delegate:PodcastSearchResultsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - API Actions
    
    func searchPodcasts(searchTerm: String) {
        weak var weakSelf = self
        let normalizedSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        PodcastService.searchPodcasts(normalizedSearchTerm, completion: {(result) -> Void in
            var podcasts = [NSMutableDictionary]()
            if let podcastArray = result {
                for dict in podcastArray {
                    let mutableCopy = dict.mutableCopy() as! NSMutableDictionary
                    podcasts.append(mutableCopy)
                }
                weakSelf?.podcasts = podcasts
                weakSelf?.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if podcasts.count < 10 { // API doesn't allow limits; enforcing one here.
            return podcasts.count
        } else {
            return 10
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(searchResult, forIndexPath: indexPath)
        let podcast = podcasts[indexPath.row]
        let json = JSON(podcast)
        cell.textLabel?.text = json["title"].stringValue
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        podcastSelected = podcasts[indexPath.row]
        delegate?.podcastSelectedFromSearchResults(self)
    }

}
