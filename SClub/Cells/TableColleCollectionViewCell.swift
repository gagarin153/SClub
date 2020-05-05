import UIKit

class TableColleCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var tableView: UITableView!
    
    var handler: ((_ vc: UIViewController) -> ())?
    private var chats = [Chat]()

    private let chatId = "ChatID"
    override func awakeFromNib() {
        super.awakeFromNib()
        super.awakeFromNib()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: chatId)
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
       
     }
     
     func setupCell(chats:[Chat]){
         self.chats = chats
         self.tableView.reloadData()
     }
     

}

extension TableColleCollectionViewCell:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 55
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatId, for: indexPath)
       
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .lightBlack
        cell.addLine(color: .separator, width: 0.5)
        cell.textLabel?.text = chats[indexPath.row].name
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
