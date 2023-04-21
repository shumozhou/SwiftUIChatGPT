//
//  HomeView.swift
//  OpenAI chat-dalle
//
//  Created by 123 周 on 2023/4/18.
//

import SwiftUI

struct HomeView: View {
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
                
                UserPage().tabItem{
                    Label("tadie", systemImage: "person.crop.circle")
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
