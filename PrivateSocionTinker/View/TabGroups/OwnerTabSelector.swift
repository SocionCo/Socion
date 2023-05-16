//
//  TabSelector.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/7/23.
//

import SwiftUI

struct OwnerTabView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var selection = 2
    var body: some View {
        withAnimation {
            TabView(selection: $selection) {
                ErrorView().tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Payments")
                }.tag(1)
                if (userViewModel.user.isAgencyOwner) {
                    ManagerContractListView(agencyViewModel: userViewModel.agencyViewModel)
                        .tabItem {
                            Image(systemName: "newspaper.fill")
                            Text("View All Contracts")
                        }.tag(2)
                } else if userViewModel.user.IsTalentManager {
                    TalentManagerContractListView(agencyViewModel: userViewModel.agencyViewModel)
                        .tabItem {
                            Image(systemName: "newspaper.fill")
                            Text("View All Contracts")
                        }.tag(2)
                } else {
                    ErrorView()
                        .tabItem {
                            Image(systemName: "newspaper.fill")
                            Text("View All Contracts")
                        }.tag(2)
                }
                AgencyView().tabItem {
                    Image(systemName: "person.3.sequence")
                    Text("Agency Dashboard")
                }
                .opacity(1.0)
                .tag(3)
            }.onAppear() {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}


