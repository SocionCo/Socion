import SwiftUI

struct ViewTest: View {
    @EnvironmentObject private var userViewModel : UserViewModel
    @Binding var selected : Bool
    @EnvironmentObject var authentication : Authentication
    var isSignInButtonDisabled: Bool {
        userViewModel.registerDisable
    }
    @State var offWhite : Color = Color(red: 247/255, green: 247/255, blue: 247/255)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 28/255, green: 168/255, blue: 141/255), Color(red: 5/255, green: 117/255, blue: 230/255)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 150, height: 150)
                    
                    Image("SocionCircle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                }
                .padding(.bottom, 30)
                
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
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
                    
                    Button(action: {
                        userViewModel.logIn { success in
                            authentication.updateValidation(success: success)
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color("ButtonColor"))
                            .cornerRadius(15.0)
                    }.background(
                        isSignInButtonDisabled ?
                            .gray : .black)
                    .disabled(isSignInButtonDisabled)
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
                    selected = false
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right").foregroundColor(offWhite)
                }
            }
        }
    }
}
