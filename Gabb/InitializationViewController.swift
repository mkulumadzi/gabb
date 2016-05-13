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

private let showMainView = "ShowMainView"

let screenSize: CGRect = UIScreen.mainScreen().bounds

var searchImageSize: CGSize {
    return CGSize(width: 30.0, height: 30.0)
}

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
        let listening = NSMutableDictionary()
        listening.setValue("Continue Listening", forKey: "title")
        listening.setValue("/listening", forKey: "podcasts_url")
        podcastGroups.append(listening)
        
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
                self.performSegueWithIdentifier(showMainView, sender: nil)
            }
        })
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == showMainView) {
            if let vc = segue.destinationViewController as? MainViewController {
                vc.podcastGroups = self.podcastGroups
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

