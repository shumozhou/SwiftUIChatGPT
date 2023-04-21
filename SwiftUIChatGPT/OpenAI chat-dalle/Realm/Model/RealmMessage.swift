import Foundation
import RealmSwift

class RealmMessage: Object, Identifiable, Codable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var content: String = ""
    @objc dynamic var type: Int = 0
    @objc dynamic var isUserMessage: Bool = false
    @objc dynamic var createdAt = Date()
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
