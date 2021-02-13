//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //when user clicks register button...
    @IBAction func registerPressed(_ sender: UIButton) {
        //optional chaining - both need to have value, for if statement to occur

        if let email = emailTextfield.text, let password = passwordTextfield.text {
            //standard firestoreAuth method to create user
            //docs here: https://firebase.google.com/docs/auth/ios/password-auth#create_a_password-based_account
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                //show error on label on UI
                self.errorLabel.text = e.localizedDescription
            } else {
                //navigate to message view if successful
                //accessing 'K' constant type, then tap into registerSegue value
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
        }
    }
    
}
}
