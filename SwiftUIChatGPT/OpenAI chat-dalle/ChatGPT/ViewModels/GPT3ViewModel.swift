import Foundation
import ChatGPTSwift
import RealmSwift

class GPT3ViewModel: ObservableObject {
    let api = ChatGPTAPI(apiKey: UserDefaults.standard.string(forKey: "APIKEY") ?? "")
    @Published var messages = [Message]()
    private var messagesResults: Results<RealmMessage>
    private var notificationToken: NotificationToken?
    init() {
        let realm = try! Realm()
        messagesResults = realm.objects(RealmMessage.self).sorted(byKeyPath: "createdAt", ascending: true)
        notificationToken = messagesResults.observe { [weak self] _ in
//            self?.loadMessages()
        }
        loadMessages()
    }
    
    func addMessage(text: String) {
            let message = RealmMessage()
            message.content = text
            let realm = try! Realm()
            try! realm.write {
                realm.add(message)
            }
        }
    
    func loadMessages() {
        messages.removeAll()
        for item in messagesResults {
            let m = Message(content: item.content, type: MessageType(rawValue: item.type) ?? .text, isUserMessage: item.isUserMessage)
            messages.append(m)
        }
//        messages = Array(messagesResults)
        
        
        
    }
        
    func getResponse(text: String) async{
        self.addMessage(text, type: .text, isUserMessage: true)
        self.addMessage("", type: .indicator, isUserMessage: false)
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await line in stream {
                DispatchQueue.main.async {
                    print("line::::" + line)
                    self.messages[self.messages.count - 1].type = .text
                    self.messages[self.messages.count - 1].content = self.messages[self.messages.count - 1].content as! String + line
                    let realm = try! Realm()
                    if let realmMessage = realm.objects(RealmMessage.self).sorted(byKeyPath: "createdAt", ascending: false).first {
                        try! realm.write {
                            realmMessage.type = MessageType.text.rawValue
                            realmMessage.content = self.messages[self.messages.count - 1].content as! String + line
                        }
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                let error = error.localizedDescription
                self.messages[self.messages.count - 1].type = .error
                self.messages[self.messages.count - 1].content = error
                let realm = try! Realm()
                if let realmMessage = realm.objects(RealmMessage.self).sorted(byKeyPath: "createdAt", ascending: false).first {
                    try! realm.write {
                        realmMessage.type = MessageType.error.rawValue
                        realmMessage.content = error
                    }
                }
            }
           
//            self.addMessage(error.localizedDescription, type: .error, isUserMessage: false)
        }
    }
    
    private func addMessage(_ content: Any, type: MessageType, isUserMessage: Bool) {
        DispatchQueue.main.async {
            // if messages list is empty just addl new message
            guard let lastMessage = self.messages.last else {
                let message = Message(content: content, type: type, isUserMessage: isUserMessage)
                self.messages.append(message)
                let realmMessage = RealmMessage()
                realmMessage.content = content as! String
                realmMessage.createdAt = Date()
                realmMessage.type = type.rawValue
                realmMessage.isUserMessage = isUserMessage
                let realm = try! Realm()
                try! realm.write {
                    realm.add(realmMessage)
                }
                return
            }
            let message = Message(content: content, type: type, isUserMessage: isUserMessage)
            // if last message is an indicator switch with new one
            if lastMessage.type == .indicator && !lastMessage.isUserMessage {
                self.messages[self.messages.count - 1] = message
                let realm = try! Realm()
                if let realmMessage = realm.objects(RealmMessage.self).sorted(byKeyPath: "createdAt", ascending: false).first {
                    try! realm.write {
                        realmMessage.content = message.content as! String
                        realmMessage.type = type.rawValue
                        realmMessage.isUserMessage = message.isUserMessage
                    }
                }
            } else {
                // otherwise, add new message to the end of the list
                self.messages.append(message)
                let realmMessage = RealmMessage()
                realmMessage.content = content as! String
                realmMessage.createdAt = Date()
                realmMessage.type = type.rawValue
                realmMessage.isUserMessage = isUserMessage
                let realm = try! Realm()
                try! realm.write {
                    realm.add(realmMessage)
                }
            }
            
            if self.messages.count > 100 {
                self.messages.removeFirst()
            }
        }
    }
    
}
