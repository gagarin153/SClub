import UIKit

class ChatsCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var tableView: UITableView!
    var handler: ((_ vc: UIViewController) -> ())?
    var handler2: ((String, String)->())!
    var handler3: ((String)->())!
    
    var pageNumber: Int!
    private var chats = [Chat]()

    private let chatId = "ChatID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: chatId)
        self.tableView.keyboardDismissMode = .onDrag
        
    }
    
    
    
     func setupCell(chats:[Chat]){
         self.chats = chats
         self.tableView.reloadData()
     }
    
   
    
}

   


extension ChatsCollectionViewCell:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 55
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatId, for: indexPath) as! TableViewCell
       
        cell.textLabel?.text = chats[indexPath.row].name
        cell.awakeFromNib()
        if pageNumber != 0 {
            cell.chat = chats[indexPath.row]
            cell.pageNumber = pageNumber
            cell.showAlert = handler2
            cell.deleteFromRecentlyChat = handler3
            cell.activateDeleteButton()
        } else {
            cell.deactivateDeletebutton()
        }
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let  chat =  chats[indexPath.row] 
       let vc = ChatViewController()
       vc.title = chat.name
       vc.chat = chat
        handler!(vc)
   }
    
}

