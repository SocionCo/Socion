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

/// Log-In view for the app
struct LogInView: View {
    @EnvironmentObject private var userViewModel : UserViewModel
    @State var showPassword : Bool = false
    @EnvironmentObject var authentication : Authentication
    @Binding var selected : Bool
    @State var offWhite : Color = Color(red: 247/255, green: 247/255, blue: 247/255)
    @State var socionGreen : Color = Color(red: 183/255, green: 235/255, blue: 181/255)

    
    var isSignInButtonDisabled: Bool {
        userViewModel.registerDisable
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Spacer()
                        Image("SocionCircle").resizable().aspectRatio(UIImage(named:"SocionCircle")!.size,contentMode: .fill)
                        Spacer()
                    }
                    Spacer()
                    TextField("Name",
                              text: $userViewModel.user.email ,
                              prompt: Text("Email").foregroundColor(offWhite)
                    ).keyboardType(.emailAddress)
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(offWhite, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .foregroundColor(Color(.white))
                        .fontWeight(.medium)
                    HStack {
                        Group {
                            if showPassword {
                                TextField("Password", // how to create a secure text field
                                          text: $userViewModel.user.password,
                                          prompt: Text("Password")
                                    .foregroundColor(offWhite))
                                .textInputAutocapitalization(.none)
                                .autocorrectionDisabled(true)
                            }
                            else {
                                SecureField("Password",
                                            text: $userViewModel.user.password,
                                            prompt: Text("Password")
                                    .foregroundColor(offWhite))
                                .textInputAutocapitalization(.none)
                                .autocorrectionDisabled(true)
                            }
                        }
                        
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(offWhite, lineWidth: 2)
                        }
                        .foregroundColor(Color(.white))
                        .fontWeight(.medium)
                        
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(offWhite)
                        }
                        
                    }.padding(.horizontal)
                    
                    Spacer()
                    logInButton
                    Spacer()
                    
            }
                    
                if userViewModel.loading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(5)
                        Spacer()
                    }
                }
            }
            .background(socionGreen)
            .autocorrectionDisabled()
            .alert(item: $userViewModel.error) {
                error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription))
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    selected = false
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right").foregroundColor(offWhite)
                }
            }
        }
    }
    
    var logInButton : some View {
        Button {
            userViewModel.logIn { success in
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
            Color(red: 0.6, green: 0.6, blue: 0.6) : (Color(red: 157/255, green: 221/255, blue: 155/255))
        )
        .cornerRadius(20)
        .disabled(isSignInButtonDisabled)
        .padding(.init(top: 10, leading: 10, bottom: 0, trailing: 10))
    }
}
//
//struct LogInView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogInView()
//    }
//}
