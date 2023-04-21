//
//  ContentView.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 3/31/23.
//

import SwiftUI
import CoreData
import FirebaseAuth


import SwiftUI

struct AgencyRegistrationView: View {
    @Binding var selected : Bool
    @EnvironmentObject private var userViewModel : UserViewModel
    @EnvironmentObject var authentication : Authentication
    @State var agencyName : String = ""
    @State var isPublic : Bool = false
    
    var buttonDisabled : Bool {
        agencyName.isEmpty
    }
    
    var body : some View {
        NavigationView {
                    Form{
                        Section(header: Text("Agency Information")) {
                            TextField("Agency Name", text: $agencyName).autocorrectionDisabled(true)
                        }
                        Section {
                            Toggle(isOn: $isPublic, label: {
                                HStack {
                                    Text("Agree to our")
                                    Link("terms of Service", destination: URL(string: "https://www.example.com/TOS.html")!)
                                }
                            })
                            submitButton.disabled(buttonDisabled)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                        }
                    }
                }.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                selected = false
                            }
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right").foregroundColor(.white)
                        }
                    }
                }
            }
    
    
    var submitButton : some View {
        Button(action: {
            userViewModel.createAgencyForUser(agencyName: agencyName)
        }) {
            HStack {
                Spacer()
                Text("Register")
                Spacer()
            }
        }
    }
}





