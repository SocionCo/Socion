import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("lightGreen"), Color("darkGreen")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "lock.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                
                Text("Log In")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                VStack(spacing: 20) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8.0)
                        .padding(.horizontal, 20)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8.0)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
                
                Button(action: {}, label: {
                    Text("Log In")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color("buttonGreen"))
                        .cornerRadius(30.0)
                })
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
