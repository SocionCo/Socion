import SwiftUI


struct ViewTest: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TikTokFollowerCountView()
                TikTokFollowerCountView()
                TikTokFollowerCountView()
            }
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.green.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
    }
}
