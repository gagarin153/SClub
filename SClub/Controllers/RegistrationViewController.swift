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
    
    @IBAction func pressSignUP(_ sender: UIButton) {
            
        
        
        
        guard let email = loginTextField.text, let password = passwordTextField.text, email != "", password != ""
        else { return }
        
        var loginErrorText = isValid(loginTextField.text ?? "") ? "" : "The email address is badly formatted."
        
        Auth.auth().createUser(withEmail: (loginTextField.text ?? ""), password: (passwordTextField.text ?? "")) { (result, error) in
            if error != nil || loginErrorText != "" {
                loginErrorText = error == nil ? loginErrorText : error!.localizedDescription
                let alert = UIAlertController(title: "Error", message: loginErrorText, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                result?.user.sendEmailVerification(completion: nil)
                self.delegate?.printPricol(string: "Before entering you need to confirm your mail. We sent an email on \(self.loginTextField.text ?? "")")
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
   
  
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Keyboard.hide(for: loginTextField, passwordTextField )
    }
    
    
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func setAttribute() {
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        loginTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
       
    }
}
