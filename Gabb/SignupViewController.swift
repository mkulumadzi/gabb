//
//  SignupViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/21/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

private let enterPassword = "EnterPassword"

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var givenNameTextField: UITextField!
    @IBOutlet weak var familyNameTextField: UITextField!
    
    var user:GabbUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    func initializeView() {
        givenNameTextField.delegate = self
        givenNameTextField.tag = 0
        
        familyNameTextField.delegate = self
        familyNameTextField.tag = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        givenNameTextField.becomeFirstResponder()
    }
    
    // MARK: Text Field actions
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case 0:
            user.givenName = textField.text
        case 1:
            user.familyName = textField.text
        default:
            print("This should not happen.")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            textField.resignFirstResponder()
            familyNameTextField.becomeFirstResponder()
        case 1:
            textField.resignFirstResponder()
            performSegueWithIdentifier(enterPassword, sender: self)
        default:
            print("This should not happen.")
        }
        return true
    }

    // MARK: User actions
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier(enterPassword, sender: self)
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == enterPassword {
            if let vc = segue.destinationViewController as? EnterPasswordViewController {
                vc.user = self.user
            }
        }
    }
    
}
