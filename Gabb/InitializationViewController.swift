//
//  InitializationViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/25/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import AVFoundation

private let browsePodcasts = "BrowsePodcasts"

let screenSize: CGRect = UIScreen.mainScreen().bounds

var thumbnailSize: CGSize {
    let x = (screenSize.width - 8) / 3
    return CGSize(width: x, height: x)
}

var fullSize: CGSize {
    let x = screenSize.width
    return CGSize(width: x, height: x)
}

var gabber:GabbPlayer!

class InitializationViewController: UIViewController {

    @IBOutlet weak var logoLabel: UILabel!
    var podcasts = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
        configureAudioForBackgroundMode()
        getPodcasts()
    }
    
    func formatView() {
        self.view.backgroundColor = UIColor.gabbRedColor()
        logoLabel.font = UIFont.logoLarge()
        logoLabel.textColor = UIColor.whiteColor()
    }
    
    // MARK: - API
    
    func getPodcasts() {
        PodcastService.getPopularPodcasts({(podcastArray) -> Void in
            if let podcastArray = podcastArray {
                for dict in podcastArray {
                    let mutableCopy = dict.mutableCopy() as! NSMutableDictionary
                    self.podcasts.append(mutableCopy)
                }
                self.performSegueWithIdentifier(browsePodcasts, sender: nil)
            }
        })
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == browsePodcasts) {
            if let nav = segue.destinationViewController as? UINavigationController {
                if let browseVc = nav.viewControllers.first as? BrowsePodcastsCollectionViewController {
                    browseVc.podcasts = self.podcasts
                }
            }
            
        }
    }
    
    // MARK: - Audio Configuration
    
    private func configureAudioForBackgroundMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}

