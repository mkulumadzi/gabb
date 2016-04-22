//
//  LoginViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/21/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var user:GabbUser!
    
    @IBOutlet weak var passwordTextField: GabbTextField!
    @IBOutlet weak var logInButton: GabbTextButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    func initializeView() {
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        passwordTextField.becomeFirstResponder()
    }
    
    // MARK: Text field delegate actions
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if logInButton.enabled {
            login()
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        logInButton.enabled = true
    }
    
    // MARK: User actions
    
    @IBAction func loginTapped(sender: AnyObject) {
        login()
    }
    
    // MARK: Private
    
    private func login() {
        logInButton.enabled = false
        passwordTextField.resignFirstResponder()
        
        guard let password = passwordTextField.text else {
            return
        }
        
        let parameters = ["username": "\(self.user.email)", "password": "\(password)"]
        LoginService.logIn(parameters, completion: { (error, result) -> Void in
            if let error = error {
                let loginError = error as NSError
                if loginError.code == 401 {
                    self.instructionsLabel.text = "Invalid login"
                } else {
                    self.instructionsLabel.text = "Login failed"
                }
            }
            else {
                print(result)
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }


}
