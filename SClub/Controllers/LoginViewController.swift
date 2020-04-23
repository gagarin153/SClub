//
//  LoginViewController.swift
//  SClub
//
//  Created by Sultan on 20.04.2020.
//  Copyright © 2020 com.Sultan. All rights reserved.
//

import UIKit




class LoginViewController: UIViewController, DataDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registration" {
            print("\n\nprepare\n\n\n")
            if let nextViewController = segue.destination as? RegistrationViewController {
                nextViewController.delegate = self
                
                
            }
        }
    }
    
    
    
    
    func setAttribute() {
        loginTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        loginTextField.autocorrectionType = .yes
        passwordTextField.autocorrectionType = .yes
        signUpButton.layer.borderWidth = 0
    }
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Keyboard.hide(for: loginTextField, passwordTextField )
    }
    
    func printPricol(string: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            let alert = UIAlertController(title: "Alert", message: string, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
}
