//
//  ProfileViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/21/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
    }
    
    func formatView() {
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        nameLabel.text = currentUser.fullName()
        emailLabel.text = currentUser.email
    }
    
    // MARK: User Actions
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logOutButtonTapped(sender: AnyObject) {
        LoginService.logOut()
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
