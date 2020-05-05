import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var titleItem: UINavigationItem!
    private let db = Firestore.firestore()
    private var globalChatsReference: CollectionReference {
        return db.collection("chats")
    }
    
    private var mineChatsReference: CollectionReference {
        return db.collection("usersCreateChats").document((Auth.auth().currentUser?.uid)!).collection("chats")
    }
    private var currentChannelAlertController: UIAlertController?
    let nickId = IndividualNumber()
    let coverView: UIView = {
        let v = UIView()
        v.backgroundColor = .mint
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let changeNameButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .black
        b.setTitleColor(UIColor.white, for: UIControl.State())
        b.setTitle("Change name", for: UIControl.State())
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let createChatButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .black
        b.setTitleColor(UIColor.white, for: UIControl.State())
        b.setTitle("Create chat", for: UIControl.State())
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
        titleItem.title = Auth.auth().currentUser?.displayName ?? " "
        setButtons()
    }
    
    func setButtons() {
        self.view.addSubview(changeNameButton)
        self.view.addSubview(createChatButton)
        
        changeNameButton.addTarget(self, action: #selector(changeNameButtonTapped), for: .touchUpInside)
        changeNameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        changeNameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeNameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        changeNameButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        createChatButton.addTarget(self, action: #selector(createChateButtonTapped), for: .touchUpInside)
        createChatButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        createChatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createChatButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createChatButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    
    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        let ac = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            do {
                try firebaseAuth.signOut()
                self.performSegue(withIdentifier: "login", sender: nil)
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }))
        present(ac, animated: true, completion: nil)
    }
    
    func createAlert(title: String, actionName: String, callFunc: @escaping () ->() ) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addTextField { field in
            field.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            field.enablesReturnKeyAutomatically = true
            field.autocapitalizationType = .words
            field.clearButtonMode = .whileEditing
            field.placeholder = "Text"
            field.returnKeyType = .done
            field.tintColor = .white
        }
        
        let createAction = UIAlertAction(title: actionName, style: .destructive, handler: { _ in
            callFunc()
        })
        createAction.isEnabled = false
        ac.addAction(createAction)
        ac.preferredAction = createAction
        
        present(ac, animated: true) {
            ac.textFields?.first?.becomeFirstResponder()
        }
        currentChannelAlertController = ac
    }
    
    @objc private func textFieldDidChange(_ field: UITextField) {
        guard let ac = currentChannelAlertController else {
            return
        }
        
        ac.preferredAction?.isEnabled = field.hasText
    }
    
    
    @objc func createChateButtonTapped() {
        createAlert(title: "Create a new chat", actionName: "Create", callFunc: createChat )
    }
    
    
    @objc func changeNameButtonTapped() {
        createAlert(title:  "Add a new name", actionName: "Change", callFunc: changeName )
    }
    
    
    private func createChat() {
        guard let ac = currentChannelAlertController else {return}
        guard let name = ac.textFields?.first?.text else {return}
        let chat = Chat(name: name + IndividualNumber.getIndividualNumber() )
        
        print(chat.representation)
        
      let id =   globalChatsReference.addDocument(data: chat.representation)  { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }.documentID
        
        mineChatsReference.document(id).setData(["name": chat.name, "date": Date(),  ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    private  func changeName() {
        guard let ac = currentChannelAlertController else { return }
        guard let newName = ac.textFields?.first?.text else { return }
        
        let nickId = IndividualNumber.getIndividualNumber()
        let changeRequest =  Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName + nickId
        changeRequest?.commitChanges { (error) in
            // print("\n\n\(error?.localizedDescription)\n\n")
        }
        titleItem.title = newName + nickId
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        }
    }
    
}
