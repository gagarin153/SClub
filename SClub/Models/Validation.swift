import Foundation

struct Validation {
    
    private var emailIsSuitable = true // если не инициализиовать, то компилятор выдаст ошибку
    private var passwordIsSuitable = true
    
    init(email: String, password: String) {
        emailIsSuitable = isValidEmail(email)
        passwordIsSuitable = isValidPassword(password)
    }
    
    private  func isValidEmail(_ email: String) -> Bool  {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: email)
       }
       
    private   func isValidPassword(_ password: String) -> Bool {
           let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
           return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func error() -> String? {
        switch (emailIsSuitable, passwordIsSuitable) {
        case (false, _ ):
            return "The email address is badly formatted."
        case (_, false):
            return "Password must be more than 8 characters, with at least one capital, numeric or special character."
        default:
            return nil
        }
    }
}
