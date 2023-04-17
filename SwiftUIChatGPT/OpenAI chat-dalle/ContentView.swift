import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            TabView {
                GPT3View()
                .tabItem{
                    Label("tadie's BOT", systemImage: "ellipses.bubble")
                }
                DalleView().tabItem{
                    Label("tadie's DALL", systemImage: "paintbrush")
                }
                
                MineView().tabItem{
                    Label("tadie", systemImage: "person.crop.circle")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

