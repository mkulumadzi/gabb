//
//  BrowsePodcastsCollectionViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/26/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PodcastCell"
private let viewPodcast = "ViewPodcast"

class BrowsePodcastsCollectionViewController: UICollectionViewController {
    
    var podcasts:[NSMutableDictionary]!

    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
        getPodcastImages()
    }
    
    func formatView() {
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.logoSmall(), NSForegroundColorAttributeName : UIColor.gabbRedColor()]
        navigationItem.title = "Gabb"
    }
    
    func getPodcastImages() {
        for podcast in podcasts {
            if let imageURL = podcast.valueForKey("image_url") as? String {
                FileService.getThumbnailImageForURL(imageURL, completion: {(image) -> Void in
                    if let image = image {
                        podcast.setValue(image, forKey: "imageThumb")
                        self.collectionView?.reloadData()
                    }
                })
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        return thumbnailSize
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PodcastCollectionViewCell
        cell.podcast = podcasts[indexPath.row]
        if let image = cell.podcast["imageThumb"] as? UIImage {
            cell.imageView.hidden = false
            cell.imageView.image = image
            cell.titleLabel.hidden = true
        }
        else if (cell.podcast["image_url"] as? String) != nil {
            cell.imageView.image = nil
            cell.imageView.hidden = false
            cell.titleLabel.hidden = true
        }
        else {
            cell.imageView.image = nil
            cell.imageView.hidden = true
            cell.titleLabel.hidden = false
            if let podcastTitle = cell.podcast["title"] as? String {
                cell.titleLabel.text = podcastTitle
            }
            else {
                cell.titleLabel.text = ""
            }
        }
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PodcastCollectionViewCell
        self.performSegueWithIdentifier(viewPodcast, sender: cell)
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
