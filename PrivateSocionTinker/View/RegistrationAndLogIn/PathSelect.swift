//
//  PathSelect.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/1/23.
//

import SwiftUI

struct PathSelect: View {
    @Binding var registered : Bool
    @Binding var selected : Bool
    @Binding var agencyRegistration : Bool
    var body: some View {
        VStack {
            Button {
                registered = false
                selected = true
            } label: {
                Text("Register")
            }
            Button {
                registered = true
                selected = true
            } label: {
                Text("Log In")
            }
            Button {
                registered = true
                selected = true
                agencyRegistration = true
            } label: {
                Text("Create Agency")
            }
        }
    }
}

//struct PathSelect_Previews: PreviewProvider {
//    static var previews: some View {
//        PathSelect()
//    }
//}
