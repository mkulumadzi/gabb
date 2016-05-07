//
//  BrowsePodcastsTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 5/3/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import SwiftyJSON

private let groupHeader = "GroupHeader"
private let podcastCollectionCell = "PodcastCollectionCell"
private let viewPodcast = "ViewPodcast"
private let viewPodcastGroup = "ViewPodcastGroup"
private let borderCell = "BorderCell"
private let searchResults = "PodcastSearchResults"

class BrowsePodcastsTableViewController: UITableViewController, PodcastCollectionTableViewCellDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, PodcastSearchResultsDelegate {
    
    var podcastGroups:[NSMutableDictionary]!
    var podcastSelected:NSMutableDictionary!
    
    var navBarBackgroundImage:UIImage?
    var navBarShadowImage:UIImage?
    
    var searchController:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarBackgroundImage = navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
        navBarShadowImage = navigationController?.navigationBar.shadowImage
        
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getPodcasts()
        formatView()
    }
    
    func formatView() {
        showDefaultNavBar()
    }
    
    func showDefaultNavBar() {
        addSearchButton()
        
        if let _ = currentUser {
            addProfileButton()
        }
        else {
            addLogoutButton()
        }
        
        navigationItem.titleView = nil
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
    
    func getPodcasts() {
        weak var weakSelf = self
        for group in podcastGroups {
            let json = JSON(group)
            PodcastService.getPodcastsForEndpoint(json["podcasts_url"].stringValue, completion: {(podcastArray) -> Void in
                var podcasts = [NSMutableDictionary]()
                if let podcastArray = podcastArray {
                    for dict in podcastArray {
                        let mutableCopy = dict.mutableCopy() as! NSMutableDictionary
                        podcasts.append(mutableCopy)
                    }
                }
                group.setValue(podcasts, forKey: "podcasts")
                weakSelf?.tableView.reloadData()
            })
        }
    }
    
    func addProfileButton() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "person"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(self.viewProfile))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func addLogoutButton() {
        let rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .Done, target: self, action: #selector(self.login))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func addSearchButton() {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(self.search))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }


    // MARK: - Table view data source
    
    func shouldShowSection(section: Int) -> Bool {
        let group = podcastGroups[section]
        if let podcasts = group["podcasts"] as? [NSMutableDictionary] {
            if podcasts.count > 0 {
                return true
            }
        }
        return false
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if shouldShowSection(section) == true {
            return 1.0
        }
        return 0.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if shouldShowSection(indexPath.section) == true {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if shouldShowSection(section) == true {
            let cell = tableView.dequeueReusableCellWithIdentifier(borderCell)
            return cell
        }
        return nil
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return podcastGroups.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.tableView(tableView, headerCellForIndexPath: indexPath)
        } else {
            return self.tableView(tableView, podcastCollectionCellForIndexPath: indexPath)
        }
    }
    
    func tableView(tableVeiw: UITableView, headerCellForIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(groupHeader, forIndexPath: indexPath)
        
        let group = JSON(podcastGroups[indexPath.section])
        cell.textLabel?.text = group["title"].stringValue
        return cell
    }
    
    func tableView(tableVeiw: UITableView, podcastCollectionCellForIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(podcastCollectionCell, forIndexPath: indexPath) as! PodcastCollectionTableViewCell
        let group = JSON(podcastGroups[indexPath.section])
        cell.podcastGroup = group
        cell.podcastCollectionView.delegate = cell
        cell.podcastCollectionView.dataSource = cell
        cell.podcastCollectionViewHeight.constant = thumbnailSize.height + 48 // Clean this up
        
        if let podcasts = podcastGroups[indexPath.section]["podcasts"] as? [NSMutableDictionary] {
            cell.podcasts = podcasts
            cell.podcastCollectionView?.reloadData()
        }
        
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let collectionIndexPath = NSIndexPath(forRow: 1, inSection: indexPath.section)
            let cell = tableView.cellForRowAtIndexPath(collectionIndexPath)
            self.performSegueWithIdentifier(viewPodcastGroup, sender: cell)
        }
    }
    
    // MARK: - User actions
    
    func podcastSelected(cell: PodcastCollectionTableViewCell) {
        podcastSelected = cell.podcast
        performSegueWithIdentifier(viewPodcast, sender: nil)
    }
    
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
    
    // MARK: - Search
    
    func search() {
        print("Let's search!")
        let searchResultsController = storyboard?.instantiateViewControllerWithIdentifier(searchResults) as! PodcastSearchResultsTableViewController
        searchResultsController.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        presentViewController(searchController, animated: true, completion: {})
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchResultsController = searchController.searchResultsController as? PodcastSearchResultsTableViewController else {
            return
        }
        if let searchTerm = searchController.searchBar.text {
            searchResultsController.searchPodcasts(searchTerm)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        showDefaultNavBar()
    }
    
    func podcastSelectedFromSearchResults(vc: PodcastSearchResultsTableViewController) {
        podcastSelected = vc.podcastSelected
        weak var weakSelf = self
        searchController.dismissViewControllerAnimated(true, completion: ({(nil) -> Void in
            weakSelf?.showDefaultNavBar()
            weakSelf?.performSegueWithIdentifier(viewPodcast, sender: nil)
        }))
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == viewPodcast {
            if let vc = segue.destinationViewController as? ViewPodcastTableViewController {
                vc.podcast = podcastSelected
            }
        } else if segue.identifier == viewPodcastGroup {
            if let vc = segue.destinationViewController as? PodcastGroupCollectionViewController {
                if let cell = sender as? PodcastCollectionTableViewCell {
                    vc.podcastGroup = cell.podcastGroup
                    vc.podcasts = cell.podcasts
                }
            }
        }
    }


}
