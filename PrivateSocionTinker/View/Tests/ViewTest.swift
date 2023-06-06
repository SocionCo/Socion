import SwiftUI

struct ViewTest: View {
    @State private var isSelectingFriend = false
    @State private var selectedFriend = ""

    var body: some View {
        VStack {
            Button(action: {
                isSelectingFriend = true
            }) {
                Text("Choose Friend")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isSelectingFriend) {
                FriendSelectionView(selectedFriend: $selectedFriend)
            }

            if !selectedFriend.isEmpty {
                Text("Selected Friend: \(selectedFriend)")
                    .padding()
            }
        }
    }
}

struct FriendSelectionView: View {
    @Binding var selectedFriend: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Select a Friend")
                .font(.title)
                .padding()

            // Add your friend selection logic here
            // For simplicity, let's use a basic list of friends
            List {
                Button(action: {
                    selectedFriend = "John"
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("John")
                }
                Button(action: {
                    selectedFriend = "Sarah"
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Sarah")
                }
                Button(action: {
                    selectedFriend = "Michael"
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Michael")
                }
            }
        }
    }
}

