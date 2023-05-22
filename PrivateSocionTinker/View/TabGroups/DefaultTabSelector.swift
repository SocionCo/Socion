//
//  TabSelector.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/7/23.
//

import SwiftUI

struct DefaultTabSelector: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var selection = 2
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
                NoAgencyView().tabItem {
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


