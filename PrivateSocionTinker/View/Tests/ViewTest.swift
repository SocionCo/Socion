import SwiftUI
struct ViewTest: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Edit Profile")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                
                Group {
                    Text("First Name")
                    TextField("Enter First Name", text: $firstName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("GradientStart"), lineWidth: 2)
                        )
                    
                    Text("Last Name")
                    TextField("Enter Last Name", text: $lastName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("GradientStart"), lineWidth: 2)
                        )
                    
                    Text("Email")
                    TextField("Enter Email Address", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("GradientStart"), lineWidth: 2)
                        )
                    
                    Text("Password")
                    SecureField("Enter Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("GradientStart"), lineWidth: 2)
                        )
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    // Submit button action here
                }) {
                    Text("Submit")
                        .foregroundColor(Color("GradientStart"))
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: .black, radius: 2, x: 0, y: 2)
                        )
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
            .animation(.spring())
        }
    }
}
