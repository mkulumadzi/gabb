//
//  BrowsePodcastsCollectionViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/26/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

private let podcastCell = "PodcastCell"
private let continueListeningCell = "ContinueListeningCell"
private let collectionViewHeader = "CollectionViewHeader"
private let viewPodcast = "ViewPodcast"
private let browseStoryboard = "Browse"
private let episodeViewController = "episodeViewController"

class BrowsePodcastsCollectionViewController: UICollectionViewController {
    
    var podcasts:[NSMutableDictionary]!
    var categories:[NSMutableDictionary]!
    
    var continueListeningOptions = [NSDictionary]()
    
    var navBarBackgroundImage:UIImage?
    var navBarShadowImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBackgroundImage = navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
        navBarShadowImage = navigationController?.navigationBar.shadowImage
        
        getPodcastImages()
        getRecentSessions()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        formatView()
        if let _ = currentUser {
            addProfileButton()
        }
        else {
            addLogoutButton()
        }
    }
    
    func formatView() {
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.logoSmall(), NSForegroundColorAttributeName : UIColor.gabbRedColor()]
        navigationItem.title = "Gabb"
        
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
    
    func getRecentSessions() {
        SessionService.getRecentSessions({(result) -> Void in
            if let sessions = result {
                self.enableContinueListeningForSessions(sessions)
            }
        })
    }
    
    // This is real hacky and we should just make the server do it instead...
    func enableContinueListeningForSessions(sessions: [NSDictionary]) {
        for session in sessions {
            let sessionJSON = JSON(session)
            let episode:NSDictionary = ["title": sessionJSON["title"].stringValue, "audio_url": sessionJSON["episode_url"].stringValue]
            PodcastService.getPodcast(sessionJSON["podcast_id"].intValue, completion: { (result) -> Void in
                if let result = result {
                    let podcastJSON = JSON(result)["podcast"]
                    let podcast:NSDictionary = ["podcast_id": podcastJSON["podcast_id"].intValue, "title": podcastJSON["title"].stringValue, "image_url": podcastJSON["image_url"].stringValue]
                    let listeningOption:NSDictionary = ["podcast": podcast, "episode": episode]
                    self.continueListeningOptions.append(listeningOption)
                    self.collectionView?.reloadData()
                    print(self.continueListeningOptions)
                }
            })
        }
    }
    
    func addProfileButton() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "person"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(BrowsePodcastsCollectionViewController.viewProfile))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func addLogoutButton() {
        let rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .Done, target: self, action: #selector(BrowsePodcastsCollectionViewController.login))
        navigationItem.rightBarButtonItem = rightBarButtonItem
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
        if continueListeningOptions.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        return customSupplementaryView(collectionView, indexPath: indexPath, kind: kind)
        
    }
    
    func customSupplementaryView(collectionView: UICollectionView, indexPath:NSIndexPath, kind:String) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: collectionViewHeader, forIndexPath: indexPath) as! BrowsePodcastHeaderView
        
        if continueListeningOptions.count > 0 {
            switch indexPath.section {
            case 0:
                headerView.titleLabel.text = "CONTINUE LISTENING"
            default:
                headerView.titleLabel.text = "POPULAR"
            }
            
        } else {
            headerView.titleLabel.text = "POPULAR"
        }
        
        return headerView
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if continueListeningOptions.count > 0 {
            switch section {
            case 0:
                return continueListeningOptions.count
            default:
                return podcasts.count
            }
            
        } else {
            return podcasts.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        return thumbnailSize
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        if continueListeningOptions.count > 0 {
            switch indexPath.section {
            case 0:
                cell = dequeueContinueListeningCell(collectionView, indexPath: indexPath)
            default:
                cell = dequeuePodcastCell(collectionView, indexPath: indexPath)
            }
            
        } else {
            cell = dequeuePodcastCell(collectionView, indexPath: indexPath)
        }
        return cell
    }
    
    func dequeueContinueListeningCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(continueListeningCell, forIndexPath: indexPath) as! ContinueListeningCollectionViewCell
        let listeningJSON = JSON(continueListeningOptions[indexPath.row])
        cell.podcastTitle.text = listeningJSON["podcast"]["title"].stringValue
        cell.episodeTitle.text = listeningJSON["episode"]["title"].stringValue
        
        if let podcast = continueListeningOptions[indexPath.row]["podcast"] as? NSDictionary {
            cell.podcast = podcast
        }
        
        if let episode = continueListeningOptions[indexPath.row]["episode"] as? NSDictionary {
            cell.episode = episode
        }
        
        return cell
    }
    
    func dequeuePodcastCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(podcastCell, forIndexPath: indexPath) as! PodcastCollectionViewCell
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
        if continueListeningOptions.count > 0 {
            switch indexPath.section {
            case 0:
                continueListeningCellSelected(collectionView, indexPath: indexPath)
            default:
                podcastCellSelected(collectionView, indexPath: indexPath)
            }
            
        } else {
            podcastCellSelected(collectionView, indexPath: indexPath)
        }
    }
    
    func continueListeningCellSelected(collectionView: UICollectionView, indexPath:NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ContinueListeningCollectionViewCell
        let vc = fetchViewController(browseStoryboard, storyboardIdentifier: episodeViewController) as! PlayEpisodeTableViewController
        vc.podcast = cell.podcast
        vc.episode = cell.episode
        vc.presentedModally = true
        showViewController(vc, sender: self)
    }
    
    func podcastCellSelected(collectionView: UICollectionView, indexPath:NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PodcastCollectionViewCell
        self.performSegueWithIdentifier(viewPodcast, sender: cell)
    }
    
    // MARK: - User actions
    
    func viewProfile() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func login() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            presentViewController(vc, animated: true, completion: nil)
        }
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

class BrowsePodcastHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
}
