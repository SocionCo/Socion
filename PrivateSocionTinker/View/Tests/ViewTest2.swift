import SwiftUI

struct ViewTest2: View {
    let backgroundColor = Color(.sRGB, red: 0.93, green: 0.96, blue: 0.93, opacity: 1.0)
    let primaryColor = Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0)
    let secondaryColor = Color(.white)
    
    let tasks = ["Task 1", "Task 2", "Task 3"]
    @State var completedTasks = 2
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Text("Progress")
                    .font(.largeTitle)
                    .foregroundColor(primaryColor)
                
                HStack(spacing: -20) {
                    VStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(primaryColor)
                        Text(tasks[0])
                            .foregroundColor(primaryColor)
                            .font(.caption2)
                            .lineLimit(1)
                            .padding(.horizontal, 5)
                            .frame(width: 100)
                    }
                    Rectangle()
                        .fill(completedTasks >= 1 ? primaryColor : secondaryColor)
                        .frame(width: geometry.size.width * 1/6, height: 3)
                    VStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(completedTasks >= 1 ? primaryColor : secondaryColor)
                        Text(tasks[1])
                            .foregroundColor(primaryColor)
                            .font(.caption2)
                            .lineLimit(1)
                            .padding(.horizontal, 5)
                            .frame(width: 100)
                    }
                    Rectangle()
                        .fill(completedTasks >= 2 ? primaryColor : secondaryColor)
                        .frame(width: geometry.size.width * 1/6, height: 3)
                    VStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(completedTasks >= 2 ? primaryColor : secondaryColor)
                        Text(tasks[2])
                            .foregroundColor(primaryColor)
                            .font(.caption2)
                            .lineLimit(1)
                            .padding(.horizontal, 5)
                            .frame(width: geometry.size.width * 1/6
                            )
                    }
                }
                .padding()
                
                Text("Task \(completedTasks + 1) of \(tasks.count) Completed")
                    .font(.headline)
                    .foregroundColor(primaryColor)
                    .padding(.bottom, 10)
                    .padding()
            }
            .background(secondaryColor)
            .cornerRadius(10)
            .shadow(color: primaryColor.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(backgroundColor)
            .navigationBarTitle(Text("Progress"), displayMode: .inline)
        }
    }
}
