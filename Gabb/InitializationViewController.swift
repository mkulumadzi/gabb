//
//  InitializationViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/25/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

private let browsePodcasts = "BrowsePodcasts"

let screenSize: CGRect = UIScreen.mainScreen().bounds

var gabber:GabbPlayer!

class InitializationViewController: UIViewController {

    @IBOutlet weak var logoLabel: UILabel!
    var podcasts = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gabbRedColor()
        logoLabel.font = UIFont.logoLarge()
        logoLabel.textColor = UIColor.whiteColor()
        
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == browsePodcasts) {
            if let nav = segue.destinationViewController as? UINavigationController {
                if let browseVc = nav.viewControllers.first as? BrowsePodcastsCollectionViewController {
                    browseVc.podcasts = self.podcasts
                }
            }
            
        }
    }

}

