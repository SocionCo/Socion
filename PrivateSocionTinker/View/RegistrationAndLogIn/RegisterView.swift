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

struct RegisterView: View {
    @Binding var selected : Bool
    @EnvironmentObject private var userViewModel : UserViewModel
    @State var showPassword : Bool = false
    @EnvironmentObject var authentication : Authentication
    @State var isPublic: Bool = true
    @State private var showingPassword = false
    @State private var showingAlert = false
    @State var buttonDisabled = false
    
    var isSignInButtonDisabled: Bool {
        userViewModel.registerDisable
    }
    
    var body : some View {
        NavigationView {
                    Form(content: {
                        Section(header: Text("Credentials")) {
                            
                            TextField("First Name", text: $userViewModel.user.firstName).autocorrectionDisabled(true)
                            TextField("Last Name", text: $userViewModel.user.lastName).autocorrectionDisabled(true)
                            TextField("Email", text: $userViewModel.user.email).autocorrectionDisabled(true).textInputAutocapitalization(.never)
                            
                            HStack {
                                if !showingPassword {
                                    SecureField("Password", text: $userViewModel.user.password).autocorrectionDisabled(true).textInputAutocapitalization(.never)
                                } else {
                                    TextField("Password", text: $userViewModel.user.password).autocorrectionDisabled(true).textInputAutocapitalization(.never)
                                }
                                Button {
                                    showingPassword.toggle()
                                } label: {
                                    Image(systemName: showingPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
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
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Socion Registration Successful"),
                                      message: Text("Thank you \(userViewModel.user.firstName)!\n Your account has successfully been registered!"),
                                      dismissButton: .default(Text("OK")))
                            }
                            .alert(item: $userViewModel.error) {
                                error in
                                Alert(title: Text("Error"), message: Text(error.localizedDescription))
                            }
                        }
                    })
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                selected = false
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                        }
                    }
                    .navigationBarTitle("Register")
                }
            }
    
    
    var submitButton : some View {
        Button(action: {
            buttonDisabled = true
            userViewModel.register  { success in
                authentication.updateValidation(success: success)
                if success {
                    showingAlert = true
                } else {
                    print("Registration Failed")
                    buttonDisabled = false
                }
            }
        }) {
            HStack {
                Spacer()
                Text("Register")
                Spacer()
            }
        }
    }
}





