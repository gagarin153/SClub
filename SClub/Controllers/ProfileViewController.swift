//
//  ProfileViewController.swift
//  SClub
//
//  Created by Sultan on 24.04.2020.
//  Copyright © 2020 com.Sultan. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // authenticateUserAndConfigureView()
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
//            let nagigateVC = UINavigationController(rootViewController: LoginViewController())
//            self.present(nagigateVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nagigateVC = UINavigationController(rootViewController: LoginViewController())
                self.present(nagigateVC, animated: true, completion: nil)
            }
        } else {
            userIdLabel.text = Auth.auth().currentUser?.email
        }
    }
    
    
}
