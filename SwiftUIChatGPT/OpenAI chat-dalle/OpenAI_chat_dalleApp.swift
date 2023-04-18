import SwiftUI
//How to add SwiftUI to a UIKit project
@main
struct OpenAI_chat_dalleApp: App {
    let dalleViewModel = DalleViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dalleViewModel)

        }
    }
}
