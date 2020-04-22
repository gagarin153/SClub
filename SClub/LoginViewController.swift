//
//  LoginViewController.swift
//  SClub
//
//  Created by Sultan on 20.04.2020.
//  Copyright © 2020 com.Sultan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }

    func dismissKeyboard() {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}
