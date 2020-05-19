import UIKit
import FirebaseFirestore
import FirebaseAuth

class TableViewCell: UITableViewCell {
    
    var chat: Chat!
    var pageNumber: Int!
    var showAlert: ((String, String)->())!
    var deleteFromRecentlyChat: ((String)->())!
    private let db = Firestore.firestore()
    
    let deleteButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .mint
        let attributes: [NSAttributedString.Key: Any] = [
            .font:  UIFont.systemFont(ofSize: 40),
            .foregroundColor: UIColor.black,
        ]
        b.setAttributedTitle(NSAttributedString(string: "-", attributes: attributes), for: .normal)
        b.layer.cornerRadius = 15
        return b
    }()
    
    var deleteButtonConstraints: [NSLayoutConstraint]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .lightBlack
        self.addLine(color: .separator, width: 0.5)
        
        deleteButtonConstraints = [
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 30) ]
        
        
    }
    
    
    func activateDeleteButton() {
        self.addSubview(deleteButton)
        NSLayoutConstraint.activate(deleteButtonConstraints)
        deleteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    }
    func deactivateDeletebutton() {
        deleteButton.removeFromSuperview()
    }
    
    @objc func buttonTapped(sender: UIButton) {
        if pageNumber == 1  {
            deleteFromRecentlyChat(chat.id!)
        } else {
            showAlert(chat.id!, chat.name)
        }
        
    }
    
    
    
}

