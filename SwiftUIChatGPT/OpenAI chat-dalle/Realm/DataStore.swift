import Foundation
import SwiftUI
import RealmSwift

class DataStore: NSObject, ObservableObject {
    static let shared = DataStore()
    
    @Published
    var user: RealmUser?
    
    @Published
    var diaries: Results<RealmDiary>?
    
    @Published
    var publicDiaries: Results<RealmDiary>?
    
    @Published
    var messages: Results<RealmMessage>?
    
    private var token: NotificationToken? = nil
    private var realm = try! Realm()
    
    // MARK: - Object Lifecycle
    override private init() {
        super.init()
        fetchData()
        addObserver()
    }
    
    deinit {
        token?.invalidate()
    }
    
    private func fetchData() {
        user = realm.objects(RealmUser.self).filter("userID = '\(uid!)'").first
        diaries = realm.objects(RealmDiary.self).filter("userID = '\(uid!)'")
        messages = realm.objects(RealmMessage.self).filter("id = '\(uid!)'")
        publicDiaries = diaries?.filter("isPublic = 'true'")
    }
    
    private func addObserver() {
        token = realm.observe { notification, realm in
            self.fetchData()
        }
    }
}
