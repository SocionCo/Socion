//
//  TabSelector.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/7/23.
//

import SwiftUI

struct OwnerTabView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    var body: some View {
        withAnimation {
            TabView {
                ManagerContractListView(agencyViewModel: userViewModel.agencyViewModel)
                    .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("View All Contracts")
                }
                AgencyView().tabItem {
                    Image(systemName: "gear")
                    Text("View Agency Information")
                }
            }
        }
    }
}


