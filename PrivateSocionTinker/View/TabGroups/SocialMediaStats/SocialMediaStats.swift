import SwiftUI

struct SocialMediaStats: View {
    var body: some View {
        VStack {
            
            ScrollView {
                VStack(spacing: 20) {
                    SocialMediaStatsView(title: "TikTok", followers: 500000, engagementRate: 0.5, color: Color(red: 246/255, green: 90/255, blue: 86/255))
                    SocialMediaStatsView(title: "Instagram", followers: 1000000, engagementRate: 0.3, color: Color(red: 42/255, green: 159/255, blue: 214/255))
                    SocialMediaStatsView(title: "YouTube", followers: 200000, engagementRate: 0.2, color: Color(red: 255/255, green: 179/255, blue: 0/255))
                }
                .padding()
            }
        }.navigationTitle("Social Media Statistics")
    }
}

struct SocialMediaStatsView: View {
    var title: String
    var followers: Int
    var engagementRate: Double
    var color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            HStack {
                TikTokFollowerCountView()
                Spacer()
                VStack(spacing: 15) {
                    Text("Engagement:")
                    EngagementBarView(engagementRate: engagementRate, color: color)
                }
            }
            HStack {
                Button {
                    
                } label: {
                    Text("Save as PDF")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct EngagementBarView: View {
    var engagementRate: Double
    var color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(Int(engagementRate * 100))%")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 8)
                    .foregroundColor(Color(.systemGray5))
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: CGFloat(engagementRate) * 100, height: 8)
                    .foregroundColor(color)
            }
        }
    }
}

struct TikTokFollowerCountView: View {
    @State private var followerCount = [100000,60000,80000,120000,260000,25000].randomElement()!
    
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    private let updateInterval: TimeInterval = 2
    private let increaseProbability: Double = 0.8
    private let maxDelta: Int = 10
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 5) {
                        Image(systemName: "person.2")
                            .foregroundColor(.white)
                        Text("\(followerCount)")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(Color.green)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .frame(minWidth: 150, maxWidth: .infinity)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
            }
            Spacer()
        }
        .padding(10)
        .cornerRadius(10)
        .onReceive(timer) { _ in
            let delta = Int.random(in: -maxDelta...maxDelta)
            if delta > 0 || Double.random(in: 0...1) < increaseProbability {
                withAnimation(Animation.easeInOut(duration: updateInterval)) {
                    followerCount += delta
                }
            } else {
                withAnimation(Animation.easeInOut(duration: updateInterval)) {
                    followerCount -= delta
                }
            }
        }
    }
}

