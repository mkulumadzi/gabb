//
//  StartLoginViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/17/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

private let signup = "Signup"

class StartLoginViewController: UIViewController, UITextFieldDelegate {
    
    var user = GabbUser(email: nil)

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        formatView()
    }
    
    func initializeView() {
        emailTextField.delegate = self
    }
    
    func formatView() {
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: Text field delegate actions
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.text {
            user.email = text
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        goToNextScreen()
        return true
    }
    
    // MARK: User Actions

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        goToNextScreen()
    }
    
    // MARK: Private
    
    private func goToNextScreen() {
        performSegueWithIdentifier(signup, sender: self)
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == signup {
            if let vc = segue.destinationViewController as? EnterPasswordViewController {
                vc.user = self.user
            }
        }
    }
    
}
