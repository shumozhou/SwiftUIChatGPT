import SwiftUI
import RealmSwift

struct ContentView: View {
    init (){
        
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        uid = String(app.currentUser?.id ?? "")
        print(uid as Any)
        //        do {try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)}
        //        catch {
        //        print("yeet")
        //        }
        
        //        let results = realm.objects(User.self).filter("gender = 'Male'")
        //        print(results.count)
    }
    
    var body: some View {
//        HomeView()
        if app.currentUser != nil {
            HomeView()
        } else{
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

