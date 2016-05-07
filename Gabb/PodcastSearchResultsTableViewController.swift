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
        return podcasts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(searchResult, forIndexPath: indexPath)
        let podcast = podcasts[indexPath.row]
        let json = JSON(podcast)
        cell.textLabel?.text = json["title"].stringValue
        
        if let image = podcast["imageThumb"] as? UIImage {
            cell.imageView?.image = image
        } else if (podcast["image_url"] as? String) != nil {
            cell.imageView?.image = nil
            self.getPodcastImageForCell(cell, podcast: podcast)
        } else {
            cell.imageView?.image = UIImage(named: "image-placeholder")
        }
        
        return cell
    }
    
    func getPodcastImageForCell(cell: UITableViewCell, podcast:NSMutableDictionary) {
        if let imageURL = podcast.valueForKey("image_url") as? String {
            print("Getting podcast image at \(imageURL)")
            FileService.getSearchThumbnailImageForURL(imageURL, completion: {(image) -> Void in
                if let image = image {
                    podcast.setValue(image, forKey: "imageThumb")
                    cell.imageView?.image = image
                }
            })
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        podcastSelected = podcasts[indexPath.row]
        delegate?.podcastSelectedFromSearchResults(self)
    }

}
