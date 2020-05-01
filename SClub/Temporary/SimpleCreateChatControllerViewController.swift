//
//  SimpleCreateChatControllerViewController.swift
//  SClub
//
//  Created by Sultan on 27.04.2020.
//  Copyright © 2020 com.Sultan. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SimpleCreateChatControllerViewController: UIViewController {
    
    @IBOutlet weak var chatName: UITextField!
    
    
    private let db = Firestore.firestore()
    
    
    private var chatsReference: CollectionReference {
        return db.collection("chats")
    }
    
    
    private var chatslListener: ListenerRegistration?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatslListener = chatsReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
        }
        
    }
    
   
    
    @IBAction func createChatButtonTapped(_ sender: UIButton) {
        guard let name = chatName.text else { return }
        
        let chat = Chat(name: name)
        
        chatsReference.addDocument(data: chat.representation) { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Keyboard.hide(for: chatName)
    }
    
    func representation(_ text: String) -> [String : Any] {
        return  ["name": text]
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
