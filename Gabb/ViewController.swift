//
//  ViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/25/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gabbRedColor()
        logoLabel.font = UIFont.logoLarge()
        logoLabel.textColor = UIColor.whiteColor()
        
        
        PodcastService.getPopularPodcasts({(podcastArray) -> Void in
            if let podcastArray = podcastArray {
                print(podcastArray)
            }
        })
    }

}

