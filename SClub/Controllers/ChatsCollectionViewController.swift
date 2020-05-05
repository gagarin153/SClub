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
    // var container = [[Chat]]()
    var globalChats = [Chat]()
    var recentlyChats = [Chat]()
    var mineChats = [Chat]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "TableColleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
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
                self.handleDocumentChange(change, forChat: 0)
            }
        }
        
        
        recentlyChatListener = recentlyReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change, forChat: 1)
            }
        }
        
        mineChatListener = mineReference.addSnapshotListener { querySnapshot, error in
                  guard let snapshot = querySnapshot else {
                      print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                      return
                  }
                  
                  snapshot.documentChanges.forEach { change in
                      self.handleDocumentChange(change, forChat: 2)
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
    
    
    private func handleDocumentChange(_ change: DocumentChange, forChat index: Int ) {
          guard let chat = Chat(document: change.document) else {
              return
          }
          
          let  addChatFuncs = [addChatToGlobal, addChatToRecently, addChatToMine]
          
          switch change.type {
          case .added:
              addChatFuncs[index](chat)
          case .modified:
              replaceChat(chat)
          case .removed: break
          }
          
      }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TableColleCollectionViewCell
        
        cell.handler = handler
        switch indexPath.row {
        case 0:
            cell.setupCell(chats: globalChats )
        case 1:
            cell.setupCell(chats: recentlyChats)
        case 2:
            cell.setupCell(chats: mineChats)
        default:
            break
        }
        
        return cell
    }

    func handler(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension ChatsCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print()
    }
}
