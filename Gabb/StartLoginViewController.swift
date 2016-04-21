//
//  StartLoginViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/17/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

private let signup = "Signup"
private let login = "Login"

class StartLoginViewController: UIViewController, UITextFieldDelegate {
    
    private var _user:GabbUser!

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
    
    var user:GabbUser {
        if _user == nil {
            _user = GabbUser(email: nil, givenName: nil, familyName: nil)
        }
        return _user
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
        checkForExistingUser()
    }
    
    private func checkForExistingUser() {
        let params = ["email": emailTextField.text!]
        
        LoginService.checkFieldAvailability(params, completion: { (error, result) -> Void in
            if error != nil {
                print(error)
            }
            else {
                let availability = result!["email"].stringValue
                if availability == "available" {
                    self.performSegueWithIdentifier(signup, sender: nil)
                }
                else {
                    self.performSegueWithIdentifier(login, sender: nil)
                }
            }
        })
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == signup {
            if let vc = segue.destinationViewController as? SignupViewController {
                vc.user = self.user
            }
        } else if segue.identifier == login {
            if let vc = segue.destinationViewController as? LoginViewController {
                vc.user = self.user
            }
        }
    }
    
}
