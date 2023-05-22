//
//  TabSelector.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/7/23.
//

import SwiftUI

struct InfluencerTabSelector: View {
    @State private var selection = 2
    @EnvironmentObject var userViewModel : UserViewModel
    var body: some View {
        withAnimation {
            TabView(selection: $selection) {
                ErrorView().tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Payments")
                }.tag(1)
                ContractListView().tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("Contracts")
                }.tag(2)
                AgencyView().tabItem {
                    Image(systemName: "person.3.sequence")
                    Text("Agency")
                }
                .tag(3)
                .opacity(1.0)
            }.onAppear() {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}


