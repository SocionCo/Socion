import SwiftUI

struct AgencyView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.green.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 30) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .clipShape(Circle())
                        .shadow(radius: 10)

                    NavigationLink(destination: (AgencySettingsView())) {
                        navigationLinkView(destination: "Edit Agency Settings")
                    }
                    NavigationLink(destination: EditUserSettingsView()) {
                        navigationLinkView(destination: "Edit User Settings")
                    }
                    if (userViewModel.user.isAgencyOwner || userViewModel.user.IsTalentManager) {
                        NavigationLink(destination: ManageInfluencersView()) {
                            navigationLinkView(destination: "Manage Influencers")
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 80)
                .padding(.horizontal)
            }
            .navigationTitle("Dashboard")
            .foregroundColor(.white)
        }.toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct navigationLinkView : View {
    @State var destination : String
    var body : some View {
        Text(destination)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.green)
            .cornerRadius(10)
            .padding(.horizontal)
    }
    
}
