import UIKit

class LoginViewController: UIViewController, DataDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
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
    
    func printPricol(string: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            let alert = UIAlertController(title: "Alert", message: string, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
