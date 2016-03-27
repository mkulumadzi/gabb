//
//  BrowsePodcastsCollectionViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/26/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PodcastCell"

class BrowsePodcastsCollectionViewController: UICollectionViewController {
    
    var podcasts:[NSDictionary]!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.setImage()
        return cell
    }

}
