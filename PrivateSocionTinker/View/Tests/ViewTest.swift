import SwiftUI
import Foundation

struct NewUser: Identifiable {
    let id = UUID()
    let username: String
    let profileImage: Image
}

struct ViewTest: View {
    let users: [NewUser] = [
        NewUser(username: "User1", profileImage: Image(systemName: "person.crop.circle.fill")),
        NewUser(username: "User2", profileImage: Image(systemName: "person.crop.circle.fill")),
        NewUser(username: "User3", profileImage: Image(systemName: "person.crop.circle.fill")),
    ]
    
    var body: some View {
        getAgencyList(users)
    }
}


@ViewBuilder

func getAgencyList (_ users : [NewUser]) -> some View {
    ZStack {
        Color(hex: 0xeceef5)
            .ignoresSafeArea()
        ScrollView {
            VStack (alignment: .leading) {
                ForEach(users) { user in
                    NavigationLink {
                        ErrorView()
                    } label: {
                        HStack {
                            user.profileImage
                                .resizable()
                                .frame(width: 100, height: 100)
                                .padding(.leading, 10)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Campaign Name")
                                    .font(.title3)
                                    .bold()
                                    .padding(1)
                                Text("@TikTok Handle")
                                    .padding(1)
                                    .font(.body)
                                Text("In Progress")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(3)
                                    .background(.red)
                                    .cornerRadius(20)
                            }
                            .padding(.leading, 5)
                            .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(10)
                        .background(Color.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 0) //Edit this line for spacing
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ViewTest()
    }
}

extension Color {
    static let defaultGray = Color(red: 0.89, green: 0.89, blue: 0.89)
}
