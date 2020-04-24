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
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdLabel.text = Auth.auth().currentUser?.email
    }
}
