import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var titleItem: UINavigationItem!
    
    let coverView: UIView = {
        let v = UIView()
        v.backgroundColor = .mint
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let signOutButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .black
        b.setTitleColor(UIColor.white, for: UIControl.State())
        b.setTitle("Sign out", for: UIControl.State())
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    //        override func viewDidAppear(_ animated: Bool) {
    //            super.viewDidAppear(animated)
    //            let navBar = UINavigationBar(frame: CGRect(x: 0, y: 30, width: view.frame.size.width, height: 44))
    //            navBar.backgroundColor = .black
    //            view.addSubview(navBar)
    //
    //            let navItem = UINavigationItem(title: Auth.auth().currentUser?.displayName ?? "" )
    //            let signOutItem = UIBarButtonItem(title: "Sign out", style: .plain, target: nil, action: #selector(signOutButtonTapped))
    //            navItem.rightBarButtonItem = signOutItem
    //
    //            navBar.setItems([navItem], animated: false)
    //
    //        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
        //configureNavigationBar()
        setButton()
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
    
    

    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            titleItem.title = Auth.auth().currentUser?.displayName ?? " "
        }
    }
    
    
    
    func setButton() {
        self.view.addSubview(signOutButton)
        signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
    }
    
}
