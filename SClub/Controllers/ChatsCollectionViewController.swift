import UIKit
import FirebaseFirestore
import FirebaseAuth


class ChatsCollectionViewController: UIViewController {
    
    
    
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var recentlyButton: UIButton!
    @IBOutlet weak var mineButton: UIButton!
    @IBOutlet weak var globalButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    let cellId = "cellId"
    var globalChats = [Chat]()
    var recentlyChats = [Chat]()
    var mineChats = [Chat]()
    var pageNumber = 0 {
        didSet {
            // collectionView.reloadData()
        }
    }
    private var globalChatListener: ListenerRegistration?
    private var recentlyChatListener: ListenerRegistration?
    private var mineChatListener: ListenerRegistration?
    private let db = Firestore.firestore()
    private var globalReference: CollectionReference {
        return db.collection("chats")
    }
    private var recentlyReference: CollectionReference {
        return db.collection("recentlyChats").document(Auth.auth().currentUser!.uid).collection("chats")
    }
    private var mineReference: CollectionReference {
        return db.collection("usersCreateChats").document((Auth.auth().currentUser?.uid)!).collection("chats")
    }
    
    deinit {
        recentlyChatListener?.remove()
        globalChatListener?.remove()
    }
    
    
    var filteredChats = [[Chat](),[Chat](), [Chat]()]
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    //      private var currentArray: [Chat] {
    //             return !isFiltering ? chats : filteredChats
    //         }
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false}
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchController.searchBar.delegate = self
        self.collectionView.register(UINib(nibName: "ChatsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        configureNavigationBar()
        configureListeners()
    }
    
    func configureListeners() {
        globalChatListener = globalReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change, forPage: 0)
            }
        }
        
        recentlyChatListener = recentlyReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change, forPage: 1)
            }
        }
        
        mineChatListener = mineReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change, forPage: 2)
            }
        }
        
    }
    
    func configureNavigationBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.title = "#Chats"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.shadowImage = UIImage()
        buttonsContainer.addLine(color: .separator, width: 0.5)
    }
    
    
    private func handleDocumentChange(_ change: DocumentChange, forPage index: Int ) {
        guard let chat = Chat(document: change.document) else {
            return
        }
        
        let  addChatFuncs = [addChatToGlobal, addChatToRecently, addChatToMine]
        let  deleteChatFuncs = [deleteChatFromGlobal, deleteChatFromRecently, deleteChatFromMine]
        
        switch change.type {
        case .added:
            addChatFuncs[index](chat)
        case .modified:
            if index != 1 {break}
            replaceChat(chat)
        case .removed:
            deleteChatFuncs[index](chat)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch collectionView.bounds.minX {
        case 0.0:
            changeColors(forButton: 0)
        case collectionView.bounds.width:
            changeColors(forButton: 1)
        case collectionView.bounds.width * 2:
            changeColors(forButton: 2)
        default:
            break
        }
    }
    
    @IBAction func selectButtonsTapped(_ sender: UIButton) {
        switch sender {
        case globalButton:
            changeColors(forButton: 0)
            collectionView.moveToPage(number: 0)
        case recentlyButton:
            changeColors(forButton: 1)
            collectionView.moveToPage(number: 1)
        case mineButton:
            changeColors(forButton: 2)
            collectionView.moveToPage(number: 2)
        default: break
        }
    }
    
    
    
    
    func changeColors(forButton number: Int) {
        switch number  {
        case 0:
            globalButton.backgroundColor = .mint
            globalButton.setTitleColor(.black, for: .normal)
            recentlyButton.backgroundColor = .black
            recentlyButton.setTitleColor(.mint, for: .normal)
            mineButton.backgroundColor = .black
            mineButton.setTitleColor(.mint, for: .normal)
        case 1:
            globalButton.backgroundColor = .black
            globalButton.setTitleColor(.mint, for: .normal)
            recentlyButton.backgroundColor = .mint
            recentlyButton.setTitleColor(.black, for: .normal)
            mineButton.backgroundColor = .black
            mineButton.setTitleColor(.mint, for: .normal)
        case 2:
            globalButton.backgroundColor = .black
            globalButton.setTitleColor(.mint, for: .normal)
            recentlyButton.backgroundColor = .black
            recentlyButton.setTitleColor(.mint, for: .normal)
            mineButton.backgroundColor = .mint
            mineButton.setTitleColor(.black, for: .normal)
        default: break
        }
    }
    
    private func replaceChat(_ chat: Chat) {
        recentlyChats.removeAll { $0.id == chat.id}
        recentlyChats.append(chat)
        recentlyChats.sort()
        collectionView.reloadData()
    }
    
    private func deleteChatFromGlobal(_ chat: Chat) {
        globalChats.removeAll { $0.id == chat.id}
        deleteRecentlyChatFromFireStore(id: chat.id!)
        collectionView.reloadData()
    }
    
    private func deleteChatFromRecently(_ chat: Chat) {
        recentlyChats.removeAll { $0.id == chat.id}
        collectionView.reloadData()
    }
    
    private func deleteChatFromMine(_ chat: Chat) {
        mineChats.removeAll { $0.id == chat.id}
        collectionView.reloadData()
    }
    
    private func addChatToGlobal(_ chat: Chat) {
        guard !globalChats.contains(chat) else {
            return
        }
        globalChats.append(chat)
        globalChats.shuffle()
        collectionView.reloadData()
    }
    
    private func addChatToRecently(_ chat: Chat) {
        guard !recentlyChats.contains(chat) else {
            return
        }
        recentlyChats.append(chat)
        recentlyChats.sort()
        collectionView.reloadData()
    }
    
    private func addChatToMine(_ chat: Chat) {
        guard !mineChats.contains(chat) else {
            return
        }
        mineChats.append(chat)
        mineChats.sort()
        collectionView.reloadData()
    }
    
    
    
}

extension ChatsCollectionViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatsCollectionViewCell
        cell.handler = handler
        cell.handler2 = showAlert
        cell.handler3 = deleteRecentlyChatFromFireStore
        cell.pageNumber = indexPath.row
        switch indexPath.row {
        case 0:
            if !isFiltering {cell.setupCell(chats: globalChats )}
            else {cell.setupCell(chats: filteredChats[0])}
        case 1:
            if !isFiltering { cell.setupCell(chats: recentlyChats )}
            else {cell.setupCell(chats: filteredChats[0])}
        case 2:
            if !isFiltering { cell.setupCell(chats: mineChats )}
            else {cell.setupCell(chats: filteredChats[2])}
        default:
            break
        }
        
        return cell
    }
    
    func handler(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func callReloadWhileSearbarChangePosition() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.collectionView.reloadData()
            timer.invalidate()
        }
    }
    
}

extension ChatsCollectionViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let lowerCasedText = (searchController.searchBar.text!).lowercased()
        filteredChats[0] = globalChats.filter {$0.name.lowercased().contains(lowerCasedText)}
        filteredChats[1] = recentlyChats.filter {$0.name.lowercased().contains(lowerCasedText)}
        filteredChats[2] = mineChats.filter {$0.name.lowercased().contains(lowerCasedText)}
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        callReloadWhileSearbarChangePosition()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        callReloadWhileSearbarChangePosition()
    }
    
    
}

extension ChatsCollectionViewController {
    
    func deleteRecentlyChatFromFireStore(id: String) {
        self.db.collection("recentlyChats").document((Auth.auth().currentUser?.uid)!).collection("chats").document(id).delete { err in
            if let err = err {
                print("Error deleted document: \(err)")
            } else {
                print("Document successfully deleted!")
            }
        }
    }
    
    
    func showAlert(id: String, name: String) {
        
        let ac = UIAlertController(title: nil, message: "Are you sure you want delete \(name)? This chat will be removed from the shared store.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.db.collection("usersCreateChats").document((Auth.auth().currentUser?.uid)!).collection("chats").document(id).delete { err in
                if let err = err {
                    print("Error deleted document: \(err)")
                } else {
                    print("Document successfully deleted!")
                }
            }
            
            self.db.collection("chats").document(id).delete { err in
                if let err = err {
                    print("Error deleted document: \(err)")
                } else {
                    print("Document successfully deleted!")
                }
            }
            
            
        }))
        present(ac, animated: true, completion: nil)
    }
    
    
}

