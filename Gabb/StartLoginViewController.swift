//
//  StartLoginViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/17/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class StartLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
    }
    
    func formatView() {
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    // MARK: User Actions

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
