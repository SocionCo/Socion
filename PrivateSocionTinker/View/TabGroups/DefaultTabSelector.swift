//
//  TabSelector.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/7/23.
//

import SwiftUI

struct DefaultTabSelector: View {
    @EnvironmentObject var userViewModel : UserViewModel
    var body: some View {
        withAnimation {
            TabView {
                ContractListView().tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("View All Contracts")
                }
                NoAgencyView().tabItem {
                    Image(systemName: "gear")
                    Text("View Agency Information")
                }
            }
        }
    }
}


