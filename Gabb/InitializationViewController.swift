//
//  InitializationViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/25/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

private let browsePodcasts = "BrowsePodcasts"

let screenSize: CGRect = UIScreen.mainScreen().bounds

var thumbnailSize: CGSize {
    let x = (screenSize.width - 8) / 3
    return CGSize(width: x, height: x)
}

var largeThumbnailSize: CGSize {
    let x = (screenSize.width - 24) / 2
    return CGSize(width: x, height: x)
}

var fullSize: CGSize {
    let x = screenSize.width
    return CGSize(width: x, height: x)
}

var gabber:GabbPlayer!

var currentUser:GabbUser!

class InitializationViewController: UIViewController {

    @IBOutlet weak var logoLabel: UILabel!
    var podcastGroups = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
        initializeView()
        configureAudioForBackgroundMode()
        checkLogin()
        getPodcastCategories()
    }
    
    func formatView() {
        self.view.backgroundColor = UIColor.gabbRedColor()
        logoLabel.font = UIFont.logoLarge()
        logoLabel.textColor = UIColor.whiteColor()
    }
    
    func initializeView() {
        let popular = NSMutableDictionary()
        popular.setValue("Popular", forKey: "title")
        popular.setValue("/popular", forKey: "podcasts_url")
        podcastGroups.append(popular)
    }
    
    // MARK: Check login
    
    func checkLogin() {
        let token = LoginService.getTokenFromKeychain()
        if token != nil {
            LoginService.confirmTokenMatchesValidUserOnServer( { error, result -> Void in
                if result as? String == "Success" {
                    print("User is logged in.")
                }
            })
        }
    }
    
    // MARK: API
    
    func getPodcastCategories() {
        PodcastService.getPodcastCategories({(categoryArray) -> Void in
            if let categoryArray = categoryArray {
                for dict in categoryArray {
                    let mutableCopy = dict.mutableCopy() as! NSMutableDictionary
                    let json = JSON(mutableCopy)
                    mutableCopy.setValue("/category/\(json["category_id"].intValue)", forKey: "podcasts_url")
                    self.podcastGroups.append(mutableCopy)
                }
                self.performSegueWithIdentifier(browsePodcasts, sender: nil)
            }
        })
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == browsePodcasts) {
            if let nav = segue.destinationViewController as? UINavigationController {
                if let browseVc = nav.viewControllers.first as? BrowsePodcastsTableViewController {
                    browseVc.podcastGroups = self.podcastGroups
                }
            }
            
        }
    }
    
    // MARK: Audio Configuration
    
    private func configureAudioForBackgroundMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}

