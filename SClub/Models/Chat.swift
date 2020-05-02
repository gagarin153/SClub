import Foundation
import FirebaseFirestore

struct Chat {
  
  let id: String?
  let name: String
  let dateOfUse: Date?
  
  init(name: String) {
    id = nil
    dateOfUse = nil
    self.name = name
  }
  
  init?(document: QueryDocumentSnapshot) {
    let data = document.data()
    
    guard let name = data["name"] as? String else {
      return nil
    }
    
    if let date = data["date"] as? Timestamp {
        dateOfUse  = date.dateValue()
    } else { dateOfUse = nil}
    
    id = document.documentID
    self.name = name
  }
  
}

extension Chat: DatabaseRepresentation {
  
  var representation: [String : Any] {
    var rep = ["name": name]
    
    if let id = id {
      rep["id"] = id
    }
    
    return rep
  }
  
}

extension Chat: Comparable {
  
  static func == (lhs: Chat, rhs: Chat) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Chat, rhs: Chat) -> Bool {
    return lhs.dateOfUse! > rhs.dateOfUse!
  }

}

