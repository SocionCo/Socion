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

struct LogInView: View {
    @StateObject private var logInVM = LogInViewModel()
    @State var showPassword : Bool = false
    @EnvironmentObject var authentication : Authentication
    
    var isSignInButtonDisabled: Bool {
        logInVM.loginDisable
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()
            TextField("Name",
                      text: $logInVM.credentials.email ,
                      prompt: Text("Email").foregroundColor(.blue)
            ).keyboardType(.emailAddress)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled(true)
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)
            
            HStack {
                Group {
                    if showPassword {
                        TextField("Password", // how to create a secure text field
                                  text: $logInVM.credentials.password,
                                  prompt: Text("Password")
                                    .foregroundColor(.red))
                                .textInputAutocapitalization(.none)
                                .autocorrectionDisabled(true)
                }
                     else {
                        SecureField("Password",
                                    text: $logInVM.credentials.password,
                                    prompt: Text("Password")
                                        .foregroundColor(.red))
                                        .textInputAutocapitalization(.none)
                                        .autocorrectionDisabled(true)
                }
                    }
                        
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.red, lineWidth: 2)
                }
                
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.red)
                }
                
            }.padding(.horizontal)
            
            
            
            if logInVM.loading {
                HStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(5)
                    Spacer()
                }.padding(.init(top: 40, leading: 0, bottom: 0, trailing: 0))
            }
            Spacer()
            logInButton
        }
        .autocorrectionDisabled()
        .alert(item: $logInVM.error) {
            error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
        
    }
    
    var logInButton : some View {
        Button {
            logInVM.logIn { success in
                authentication.updateValidation(success: success)
            }
        } label: {
            Text("Log in")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(
            isSignInButtonDisabled ?
            LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(20)
        .disabled(isSignInButtonDisabled)
        .padding(.init(top: 10, leading: 10, bottom: 0, trailing: 10))
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
