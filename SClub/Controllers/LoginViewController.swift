import UIKit
import Firebase

class LoginViewController: UIViewController, DataDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = loginTextField.text, let password = passwordTextField.text, email != "", password != ""
            else { return }
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(with: error.localizedDescription)
            } else {
                if auth.currentUser?.isEmailVerified == true {
                    //self?.performSegue(withIdentifier: "login", sender: nil)
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    self?.showAlert(with: "Please confirm your email address first")
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registration" {
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
    
    func showAlert(with message: String ) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func warnAboutConfirmEmail(string: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            let alert = UIAlertController(title: "Alert", message: string, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
