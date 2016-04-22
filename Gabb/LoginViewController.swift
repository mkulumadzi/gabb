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
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        login()
        return true
    }
    
    // MARK: User actions
    
    @IBAction func loginTapped(sender: AnyObject) {
        login()
    }
    
    // MARK: Private
    
    private func login() {
        guard let password = passwordTextField.text else {
            return
        }
        
        let parameters = ["username": "\(self.user.email)", "password": "\(password)"]
        LoginService.logIn(parameters, completion: { (error, result) -> Void in
            if let error = error {
                print(error)
            }
            else {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }


}
