//
//  ChatsTableViewController.swift
//  SClub
//
//  Created by Sultan on 27.04.2020.
//  Copyright © 2020 com.Sultan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class ChatsTableViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let chatCellIdentifier = "chatCell"
    
    private let db = Firestore.firestore()
    
    private var chatslListener: ListenerRegistration?
    
    
    private var channelReference: CollectionReference {
        return db.collection("chats")
    }
    
    private var chats = [Chat]()
    private var filteredChats = [Chat]()
    
    //  private var chatlListener: ListenerRegistration?
    //private var
    
    deinit {
        chatslListener?.remove()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        title = "Chats"
        
        tableView.separatorStyle = .none

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let selector = #selector(printChat)
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Button ", style: .plain, target: self, action: selector)

        
    }
    
    @objc func printChat() {
        print(chats)
        
        let id = chats[0].id!
       // let ref = db.collection("chats").document()     .joined(separator: "/"))
       // db.collection("resently").document((Auth.auth().currentUser?.email)!)
        
       // db.collection(["resently", (Auth.auth().currentUser?.email)!, "chats"].joined(separator: "/"))
        
    

        db.collection("resently").document((Auth.auth().currentUser?.email)!).collection("chats").document("fwe").setData(["id": "fwe", "date": Date().description,  ]) { err in
                 if let err = err {
                     print("Error writing document: \(err)")
                 } else {
                     print("Document successfully written!")
                 }
             }
        
        
        db.collection("resently").document((Auth.auth().currentUser?.email)!).collection("chats").document().setData(["fwe": "ewfewqewf", "date": Date().description,  ]) { err in
                 if let err = err {
                     print("Error writing document: \(err)")
                 } else {
                     print("Document successfully written!")
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
      //  chats.sort()
        
        guard let index = chats.firstIndex(of: chat) else {
            return
        }
        //tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChats.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatCellIdentifier, for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = filteredChats[indexPath.row].name
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  chat = filteredChats[indexPath.row]
        let vc = ChatViewController()
        vc.title = chat.name
        vc.chat = chat
        navigationController?.pushViewController(vc, animated: false)
    }
}


extension ChatsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let lowerCasedText = (searchController.searchBar.text!).lowercased()
        filteredChats = chats.filter {$0.name.lowercased().contains(lowerCasedText)}
        
        tableView.reloadData()
    }
}


//private var isFiltering: Bool {
//      return searchController.isActive && !searchBarIsEmpty
//  }
//
//  private var currentArray: [String] {
//      return !isFiltering ? contacts : filteredContacts
//  }
