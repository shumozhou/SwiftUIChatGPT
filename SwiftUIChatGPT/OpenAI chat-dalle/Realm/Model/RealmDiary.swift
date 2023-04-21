import RealmSwift
import Foundation

class RealmDiary: Object, Identifiable, Codable {
    @objc dynamic var userID: String?
    @objc dynamic var name: String?
    @objc dynamic var date: String?
    @objc dynamic var title: String?
    @objc dynamic var mood: String?
    @objc dynamic var isPublic: String?
    @objc dynamic var value: String?
}
