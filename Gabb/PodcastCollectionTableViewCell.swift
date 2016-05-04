//
//  PodcastCollectionTableViewCell.swift
//  Gabb
//
//  Created by Evan Waters on 5/4/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

private let podcastCell = "PodcastCell"

class PodcastCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var podcastCollectionView: UICollectionView!
    @IBOutlet weak var podcastCollectionViewHeight: NSLayoutConstraint!
    
    var podcastGroup:JSON!
    var podcasts = [NSMutableDictionary]()
    var shouldGetPodcasts = true
    
    func getPodcasts() {
        weak var weakSelf = self
        PodcastService.getPodcastsForEndpoint(podcastGroup["podcasts_url"].stringValue, completion: {(podcastArray) -> Void in
            if let podcastArray = podcastArray {
                for dict in podcastArray {
                    let mutableCopy = dict.mutableCopy() as! NSMutableDictionary
                    self.podcasts.append(mutableCopy)
                }
                weakSelf?.podcastCollectionView?.reloadData()
                weakSelf?.getPodcastImages()
            }
        })
    }
    
    func getPodcastImages() {
        weak var weakSelf = self
        for podcast in podcasts {
            if let imageURL = podcast.valueForKey("image_url") as? String {
                FileService.getThumbnailImageForURL(imageURL, completion: {(image) -> Void in
                    if let image = image {
                        podcast.setValue(image, forKey: "imageThumb")
                        weakSelf?.podcastCollectionView?.reloadData()
                    }
                })
            }
        }
    }
    
    // MARK: - Collection View
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(podcastCell, forIndexPath: indexPath) as! PodcastCollectionViewCell
        
        //Clean this up
        let podcast = JSON(podcasts[indexPath.row])
        cell.titleLabel.text = podcast["title"].stringValue
        
        cell.podcast = podcasts[indexPath.row]
        if let image = cell.podcast["imageThumb"] as? UIImage {
            cell.imageView.image = image
        } else if (cell.podcast["image_url"] as? String) != nil {
            cell.imageView.image = nil
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        let size = CGSizeMake(thumbnailSize.width, thumbnailSize.height + 30.0)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PodcastCollectionViewCell
        print(cell.podcast)
    }
}
