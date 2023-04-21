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
    @EnvironmentObject private var userViewModel : UserViewModel
    @Binding var selected : Bool
    @EnvironmentObject var authentication : Authentication
    var isSignInButtonDisabled: Bool {
        userViewModel.registerDisable
    }
    @State var offWhite : Color = Color(red: 247/255, green: 247/255, blue: 247/255)
    

    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    
                    Image("SocionCircle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 20)
                        .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
                }
                .padding(.bottom, 30)
                
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                VStack {
                    VStack {
                        TextField("Username", text: $userViewModel.user.email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10.0)
                            .padding(.bottom, 20)
                        
                        SecureField("Password", text: $userViewModel.user.password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10.0)
                            .padding(.bottom, 20)
                    }.background()
                    
                    Button(action: {
                        userViewModel.logIn { success in
                            authentication.updateValidation(success: success)
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(
                                isSignInButtonDisabled ?
                                    .gray : .black)
                            .padding()
                            .frame(width: 220, height: 60)
                            .cornerRadius(15.0)
                    }
                    .disabled(isSignInButtonDisabled)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 5/255, green: 117/255, blue: 230/255), lineWidth: 2))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20.0)
                .shadow(radius: 10)
            }
            .padding()
        } .alert(item: $userViewModel.error) {
            error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    withAnimation {
                        selected = false
                    }
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right").foregroundColor(offWhite)
                }
            }
        }
    }
}
