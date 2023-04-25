import SwiftUI
struct ViewTest: View {
    @State private var showTikTok = false
    @State private var showInstagram = false
    @State private var showYouTube = false
    @State private var tiktokUsername = ""
    @State private var instagramUsername = ""
    @State private var youtubeUsername = ""

    var body: some View {
        VStack {
            HStack() {
                Text("TikTok username")
                Toggle(isOn: $showTikTok) {}
                Spacer()

                if showTikTok {
                    TextField("TikTok username", text: $tiktokUsername)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                
            }
            .padding()

            HStack() {
                Text("Instagram username")
                Toggle(isOn: $showInstagram) {}
                Spacer()

                if showInstagram {
                    TextField("Instagram username", text: $instagramUsername)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                
            }
            .padding()

            HStack() {
                Text("YouTube username")
                Toggle(isOn: $showYouTube) {}
                Spacer()

                if showYouTube {
                    TextField("YouTube username", text: $youtubeUsername)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                
            }
            .padding()
        }
    }

    func getSocialMediaUsernames() -> [String: String] {
        var usernames = [String: String]()

        if showTikTok && !tiktokUsername.isEmpty {
            usernames["TikTok"] = tiktokUsername
        }

        if showInstagram && !instagramUsername.isEmpty {
            usernames["Instagram"] = instagramUsername
        }

        if showYouTube && !youtubeUsername.isEmpty {
            usernames["YouTube"] = youtubeUsername
        }

        return usernames
    }
}
