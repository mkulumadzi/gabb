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
        getPodcastImages()
    }
    
    func getPodcastImages() {
        for podcast in podcasts {
            if let imageURL = podcast.valueForKey("image_url") as? String {
                if let image = FileService.getImageFromDirectory(imageURL) {
                    podcast.setValue(image, forKey: "image")
                    self.collectionView?.reloadData()
                }
                else {
                    RestService.downloadImage(imageURL, completion: {(image) -> Void in
                        if let image = image {
                            podcast.setValue(image, forKey: "image")
                            FileService.saveImageToDirectory(image, fileName: imageURL)
                            self.collectionView?.reloadData()
                        }
                    })
                }
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
        let cellWidth = (screenSize.width - 8) / 3
        return CGSize.init(width: cellWidth, height: cellWidth)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PodcastCollectionViewCell
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.podcast = podcasts[indexPath.row]
        if let image = cell.podcast["image"] as? UIImage {
            cell.imageView.image = image
        }
        else {
            cell.imageView.image = nil
        }
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PodcastCollectionViewCell
        self.performSegueWithIdentifier(viewPodcast, sender: cell)
    }
    
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
