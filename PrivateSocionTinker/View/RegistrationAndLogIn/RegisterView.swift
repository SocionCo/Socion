import SwiftUI

struct RegisterView: View {
    @Binding var selected : Bool
    @Binding var registered : Bool
    @EnvironmentObject private var userViewModel : UserViewModel
    @State var showPassword : Bool = false
    @EnvironmentObject var authentication : Authentication
    @State var isPublic: Bool = true
    @State private var showingPassword = false
    @State private var showingAlert = false
    @State var buttonDisabled = false
    @State var confirmPassword = ""
    @State var offWhite : Color = Color(red: 247/255, green: 247/255, blue: 247/255)
    @State private var showTikTok = false
    @State private var showInstagram = false
    @State private var showYouTube = false
    @State var tikTokUserName = ""
    @State var youtubeUserName = ""
    @State var instagramUserName = ""
    
    
    var isSignInButtonDisabled: Bool {
        userViewModel.registerDisable || confirmPassword != userViewModel.user.password
    }
    
    var passwordsMatch : Bool {
        confirmPassword == userViewModel.user.password
    }
    
    let gradientStart = Color("GradientStart")
    let gradientEnd = Color("GradientEnd")
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image("SocionCircle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 40)
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("First Name")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        TextField("Enter First Name", text: $userViewModel.user.firstName)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Last Name")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        TextField("Enter Last Name", text: $userViewModel.user.lastName)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        TextField("Enter Email Address", text: $userViewModel.user.email)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("TikTok")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        TextField("Enter TikTok Username (optional)", text: $tikTokUserName)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Youtube")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        TextField("Enter YouTube Username (optional)", text: $youtubeUserName)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Instagram")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        TextField("Enter Instagram Username (optional)", text: $instagramUserName)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                    
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        SecureField("Enter Password", text: $userViewModel.user.password)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Confirm Password")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            if !passwordsMatch {
                                Text("Passwords don't match")
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                        }
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                }
                
                Spacer()
                
                    Button(action: {
                        buttonDisabled = true
                        if (tikTokUserName != "") {
                            userViewModel.user.tikTokUserName = tikTokUserName
                        }
                        if (youtubeUserName != "") {
                            userViewModel.user.youtubeUserName = youtubeUserName
                        }
                        if (instagramUserName != "") {
                            userViewModel.user.instagramUserName = instagramUserName
                        }
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
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(!isSignInButtonDisabled ? gradientStart : Color(red: 168/255, green: 196/255, blue: 186/255))
                            .cornerRadius(25.0)
                            .fontWeight(.bold)
                    }
                    .disabled(isSignInButtonDisabled)
                    .padding()
                    
                
                
                HStack(spacing: 0) {
                    Text("Already have an account?")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        registered = true
                        selected = true
                    }) {
                        Text(" Sign In")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .underline()
                    }
                }
            }
            .padding(.horizontal, 30)
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Socion Registration Successful"),
                  message: Text("Thank you \(userViewModel.user.firstName)!\n Your account has successfully been registered!"),
                  dismissButton: .default(Text("OK")))
        }
        .alert(item: $userViewModel.error) {
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

   
