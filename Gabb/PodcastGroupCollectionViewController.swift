//
//  PodcastGroupCollectionViewController.swift
//  Gabb
//
//  Created by Evan Waters on 5/3/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

private let podcastCell = "PodcastCell"
private let viewPodcast = "ViewPodcast"

class PodcastGroupCollectionViewController: UICollectionViewController {
    
    var podcastGroup:NSMutableDictionary!
    var podcasts = [NSMutableDictionary]()
    
    var navBarBackgroundImage:UIImage?
    var navBarShadowImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBackgroundImage = navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
        navBarShadowImage = navigationController?.navigationBar.shadowImage
        
        formatView()
        getPodcasts()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func formatView() {
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(20.0), NSForegroundColorAttributeName : UIColor.gabbRedColor()]
        let json = JSON(podcastGroup)
        navigationItem.title = json["title"].stringValue
        
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
    
    func getPodcasts() {
        weak var weakSelf = self
        let group = JSON(podcastGroup)
        PodcastService.getPodcastsForEndpoint(group["podcasts_url"].stringValue, completion: {(podcastArray) -> Void in
            if let podcastArray = podcastArray {
                for dict in podcastArray {
                    let mutableCopy = dict.mutableCopy() as! NSMutableDictionary
                    self.podcasts.append(mutableCopy)
                }
                weakSelf?.collectionView?.reloadData()
            }
        })
    }
    
    func getPodcastImage(cell: PodcastCollectionViewCell) {
        if let imageURL = cell.podcast.valueForKey("image_url") as? String {
            FileService.getLargeThumbnailImageForURL(imageURL, completion: {(image) -> Void in
                if let image = image {
                    cell.podcast.setValue(image, forKey: "imageThumb")
                    cell.imageView.image = image
                }
            })
        }
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(podcastCell, forIndexPath: indexPath) as! PodcastCollectionViewCell
        
        //Clean this up
        let podcast = JSON(podcasts[indexPath.row])
        cell.titleLabel.text = podcast["title"].stringValue
        
        cell.podcast = podcasts[indexPath.row]
        if let image = cell.podcast["imageThumb"] as? UIImage {
            cell.imageView.image = image
        } else if (cell.podcast["image_url"] as? String) != nil {
            cell.imageView.image = nil
            self.getPodcastImage(cell)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        let size = CGSizeMake(largeThumbnailSize.width, largeThumbnailSize.height + 50.0)
        return size
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
