//
//  ChatsTableViewController.swift
//  SClub
//
//  Created by Sultan on 27.04.2020.
//  Copyright © 2020 com.Sultan. All rights reserved.
//

import UIKit
import FirebaseFirestore


class ChatsTableViewController: UITableViewController {
    
    private let chatCellIdentifier = "chatCell"
    
    private let db = Firestore.firestore()
    
   private var chatslListener: ListenerRegistration?

    
    private var channelReference: CollectionReference {
        return db.collection("chats")
    }
    
    private var chats = [Chat]()
  //  private var chatlListener: ListenerRegistration?
    
    deinit {
        chatslListener?.remove()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
        
        title = "Chats"

        
        chatslListener = channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }

            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        
        
    }
    

    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Chat(document: change.document) else {
         return
       }
       
       switch change.type {
       case .added:
         addChannelToTable(channel)
       case .modified: break
        
       case .removed: break
        
        }
    
    }
    
    private func addChannelToTable(_ chat: Chat) {
       guard !chats.contains(chat) else {
         return
       }
       
       chats.append(chat)
       chats.sort()
       
        guard let index = chats.firstIndex(of: chat) else {
         return
       }
       tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
     }
    
    
     override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
     }
     
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 55
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: chatCellIdentifier, for: indexPath)
       
       cell.accessoryType = .disclosureIndicator
       cell.textLabel?.text = chats[indexPath.row].name
       
       return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]

        
        let vc = ChatViewController()
        vc.title = chat.name
        vc.chat = chat
        navigationController?.pushViewController(vc, animated: false)
    }
}
