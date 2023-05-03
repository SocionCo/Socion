import SwiftUI

struct FriendRequest: Identifiable {
    let id = UUID()
    let name: String
}

struct ViewTest: View {
    @State private var friendRequests = [
        FriendRequest(name: "John"),
        FriendRequest(name: "Sarah"),
        FriendRequest(name: "Mike"),
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(friendRequests) { request in
                    HStack {
                        Text(request.name)
                            .foregroundColor(.primary)
                        Spacer()
                        Button(action: {
                            // Remove the friend request from the list when accepted
                            friendRequests.removeAll(where: { $0.id == request.id })
                        }) {
                            Text("Accept")
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.green)
                                .cornerRadius(5)
                        }
                        Button(action: {
                            // Remove the friend request from the list when denied
                            friendRequests.removeAll(where: { $0.id == request.id })
                        }) {
                            Text("Deny")
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.red)
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .navigationTitle("Friend Requests")
        }
        .accentColor(.green)
    }
}
