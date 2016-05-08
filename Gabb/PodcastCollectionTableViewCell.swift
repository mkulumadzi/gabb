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

protocol PodcastCollectionTableViewCellDelegate {
    func podcastSelected(cell: PodcastCollectionTableViewCell)
}

class PodcastCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var podcastCollectionView: UICollectionView!
    @IBOutlet weak var podcastCollectionViewHeight: NSLayoutConstraint!
    
    var podcastGroup:JSON!
    var podcasts = [NSMutableDictionary]()
    var podcast:NSMutableDictionary!
    
    var delegate:PodcastCollectionTableViewCellDelegate?
    
    func getPodcastImage(indexPath: NSIndexPath) {
        let podcast = podcasts[indexPath.row]
        weak var weakSelf = self
        if let imageURL = podcast.valueForKey("image_url") as? String {
            print("Getting podcast image at \(imageURL)")
            FileService.getThumbnailImageForURL(imageURL, completion: {(image) -> Void in
                if let image = image {
                    podcast.setValue(image, forKey: "imageThumb")
                    weakSelf?.podcastCollectionView.reloadItemsAtIndexPaths([indexPath])
                }
            })
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
        cell.imageView.image = nil
        if let image = cell.podcast["imageThumb"] as? UIImage {
            cell.imageView.image = image
        } else if (cell.podcast["image_url"] as? String) != nil {
            self.getPodcastImage(indexPath)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        let size = CGSizeMake(thumbnailSize.width, thumbnailSize.height + 30.0)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PodcastCollectionViewCell
        self.podcast = cell.podcast
        delegate?.podcastSelected(self)
    }
}
