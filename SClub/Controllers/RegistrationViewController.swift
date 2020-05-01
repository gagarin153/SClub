import UIKit
import Firebase


class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var delegate: DataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let email = loginTextField.text, let password = passwordTextField.text, email != "", password != ""
            else { return }
        
        if let loginErrorText = Validation(email: email, password: password).error() {
            self.showAlert(with: loginErrorText)
            return
        }
        
        Auth.auth().createUser(withEmail: (loginTextField.text ?? ""), password: (passwordTextField.text ?? "")) { (result, error) in
            if let error = error  {
                self.showAlert(with: error.localizedDescription)
            } else {
                let changeRequest = result?.user.createProfileChangeRequest()
                        changeRequest?.displayName = "Sultan"
                        changeRequest?.commitChanges { (error) in
                            //print("\n\n\(error?.localizedDescription)\n\n")
                        }
                
                
                result?.user.sendEmailVerification(completion: nil)
                self.delegate?.warnAboutConfirmEmail(string: "Before entering you need to confirm your mail. We sent an email on \(self.loginTextField.text ?? "")")
                result?.user.createProfileChangeRequest()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Keyboard.hide(for: loginTextField, passwordTextField )
    }
    
    func showAlert(with message: String ) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setAttribute() {
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        loginTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
    }
}
