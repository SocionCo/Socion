import SwiftUI

struct AgencyView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var authentication : Authentication
    var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.green.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 30) {
                    if userViewModel.user.profilePicture == UIImage.defaultImage {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    } else {
                        Image(uiImage: userViewModel.user.profilePicture)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }

                    NavigationLink(destination: (AgencySettingsView())) {
                        navigationLinkView(destination: "Agency Settings")
                    }
                    NavigationLink(destination: EditUserSettingsView()) {
                        navigationLinkView(destination: "User Settings")
                    }
                    if (userViewModel.user.isAgencyOwner) {
                        NavigationLink(destination: ManageInfluencersView(agencyViewModel: userViewModel.agencyViewModel)) {
                            navigationLinkView(destination: "Manage Influencers")
                        }.tint(.white)
                    }
                    
                    Button {
                        authentication.updateValidation(success: false)
                        userViewModel.logOut()
                    } label: {
                        navigationLinkView(destination: "Log Out", isRed: true)
                    }
                    
                    Spacer()
                }
                .padding(.top, 80)
                .padding(.horizontal)
                .navigationTitle("Dashboard")
                .foregroundColor(.white)
        }.accentColor(.black)
    
    }
}

struct navigationLinkView : View {
    @State var destination : String
    @State var isRed = false
    var body : some View {
        Text(destination)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(isRed ? Color(red: 1.0, green: 0.4, blue: 0.4)
 : Color.green)
            .cornerRadius(10)
            .padding(.horizontal)
    }
    
}
