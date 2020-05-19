import UIKit
import Firebase


class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nickIdLabel: UILabel!
    
    let nickId = IndividualNumber.getIndividualNumber()
    var delegate: ConfirmEmailDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        nameTextField.delegate = self
        setAttribute()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 17
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        Keyboard.hide(for: loginTextField, passwordTextField, nameTextField )
        guard let email = loginTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {return}
        
        guard name != "" , email != "", password != ""
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
                changeRequest?.displayName = name + self.nickId
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
        Keyboard.hide(for: loginTextField, passwordTextField, nameTextField )
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
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        loginTextField.addLine(color: .black, width: 1)
        passwordTextField.addLine(color: .black, width: 1)
        nameTextField.addLine(color: .black, width: 1)
        nickIdLabel.addLine(color: .black, width: 1)
        nickIdLabel.attributedText = NSAttributedString(string: nickId,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        nameTextField.autocorrectionType = .yes
        nameTextField.autocapitalizationType = .sentences
        
    }
}
