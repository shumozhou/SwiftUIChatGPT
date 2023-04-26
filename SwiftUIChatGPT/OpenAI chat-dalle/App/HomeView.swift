//
//  HomeView.swift
//  OpenAI chat-dalle
//
//  Created by 123 周 on 2023/4/18.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var dataStore = DataStore.shared
    var body: some View {
        NavigationView {
            TabView {
                GPT3View()
                .tabItem{
                    Label("\(dataStore.user?.name ?? "")'s BOT", systemImage: "ellipses.bubble")
                }
                DalleView().tabItem{
                    Label("\(dataStore.user?.name ?? "")'s DALL", systemImage: "paintbrush")
                }
                
                UserPage().tabItem{
                    Label("\(dataStore.user?.name ?? "")", systemImage: "person.crop.circle")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
