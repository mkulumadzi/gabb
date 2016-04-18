//
//  EnterPasswordViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/17/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class EnterPasswordViewController: UIViewController, UITextFieldDelegate {
    
    var user:GabbUser!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: User actions
    
    @IBAction func doneTapped(sender: AnyObject) {
        createPersonAndLogin()
    }
    
    // MARK: Private
    
    private func createPersonAndLogin() {
        guard let password = passwordTextField.text else {
            return
        }
        let newPersonURL = "http://gabb.herokuapp.com/person/new"
        let parameters = ["username": user.email, "email": user.email, "password": password]
        let headers:[String: String] = ["Accept": "application/json"]
        
        RestService.postRequest(newPersonURL, parameters: parameters, headers: headers, completion: {(error, result) -> Void in
            if let error = error {
                print(error)
            }
            else {
                if let response = result as? [AnyObject] {
                    if response[0] as? Int == 201 {
                        let parameters = ["username": "\(self.user.email)", "password": "\(password)"]
                        LoginService.logIn(parameters, completion: { (error, result) -> Void in
                            print("logged in")
                        })
                    }
                    else if let error_message = response[1] as? String {
                        print(error_message)
                    }
                }
            }
        })
    }

}
