import SwiftUI

struct ViewTest: View { 
    let backgroundColor = Color(.sRGB, red: 0.93, green: 0.96, blue: 0.93, opacity: 1.0)
    let primaryColor = Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0)
    let secondaryColor = Color(.white)
    @State var newTask: String = ""
    @State var tasks : [String] = []
    @State var isCompletedArray : [Bool] = []
    @State var completedTasks = 2
    @State var contract: Contract
    @Environment(\.dismiss) private var dismiss
    
    
    
    var body: some View {
        ScrollView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                VStack {
                    taskBar.background(backgroundColor).frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Contract Details")
                            .font(.largeTitle)
                            .foregroundColor(primaryColor)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Contract Name:")
                                    .font(.headline)
                                    .foregroundColor(primaryColor)
                                Spacer()
                                Text(contract.name)
                                    .font(.subheadline)
                                    .foregroundColor(primaryColor)
                            }
                            
                            HStack {
                                Text("ID:")
                                    .font(.headline)
                                    .foregroundColor(primaryColor)
                                Spacer()
                                Text(contract.id)
                                    .font(.subheadline)
                                    .foregroundColor(primaryColor)
                            }
                            
                            HStack {
                                Text("Start Date:")
                                    .font(.headline)
                                    .foregroundColor(primaryColor)
                                Spacer()
                                
                                Text("Yesterday")
                                    .font(.subheadline)
                                    .foregroundColor(primaryColor)
                            }
                            
                            HStack {
                                Text("End Date:")
                                    .font(.headline)
                                    .foregroundColor(primaryColor)
                                Spacer()
                                Text(Contract.dateToStringForPresentation(date: contract.dueDate) ?? "None")
                                    .font(.subheadline)
                                    .foregroundColor(primaryColor)
                            }
                            
                            HStack {
                                Text("Amount:")
                                    .font(.headline)
                                    .foregroundColor(primaryColor)
                                Spacer()
                                Text("$\(contract.rate ?? 0.0)")
                                    .font(.subheadline)
                                    .foregroundColor(primaryColor)
                            }
                            
                            HStack {
                                Text("Status:")
                                    .font(.headline)
                                    .foregroundColor(primaryColor)
                                Spacer()
                                Text(contract.status.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(primaryColor)
                            }
                            
                        }
                        .padding()
                        .background(secondaryColor)
                        .cornerRadius(10)
                        .shadow(color: primaryColor.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Spacer()
                    }
                    .padding()
                    .background(backgroundColor)
                    taskMenu.background(backgroundColor)
                    
                    Spacer()
                }
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward").foregroundColor(.white)
                }
            }
        }.navigationBarBackButtonHidden(true)
        
    }
    
    
    var taskMenu : some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                Text("Tasks")
                    .font(.largeTitle)
                    .foregroundColor(primaryColor)
                
                VStack{
                    HStack {
                        TextField("New task", text: $newTask)
                            .padding(.horizontal)
                            .foregroundColor(primaryColor)
                            .frame(height: 44)
                            .background(secondaryColor)
                            .cornerRadius(10)
                        
                        Button(action: {
                            tasks.append(newTask)
                            isCompletedArray.append(false)
                            newTask = ""
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(primaryColor)
                                .font(.title)
                        })
                    }
                    
                    ForEach(tasks, id: \.self) { task in
                        HStack {
                            if (isCompletedArray[tasks.firstIndex(of: task)!]) {
                                Text(task)
                                    .font(.headline)
                                    .foregroundColor(primaryColor)
                                    .strikethrough(true)
                            } else {
                                Text(task)
                                    .font(.headline)
                                    .foregroundColor(primaryColor)
                            }
                            Spacer()
                            Button(action: {
                                isCompletedArray.remove(at: tasks.firstIndex(of: task)!)
                                tasks.remove(at: tasks.firstIndex(of: task)!)
                                
                            }, label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(primaryColor)
                                    .font(.title)
                            })
                        }
                    }
                    
                }
                .padding()
                .background(secondaryColor)
                .cornerRadius(10)
                .shadow(color: primaryColor.opacity(0.2), radius: 10, x: 0, y: 5)
                
                Spacer()
            }
            .padding()
            .background(backgroundColor)
        }
    }
    
    var taskBar : some View {
        ZStack {
                backgroundColor.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Progress")
                        .font(.largeTitle)
                        .foregroundColor(primaryColor)
                    
                    VStack{
                        HStack(spacing: -20) {
                            Spacer()
                            ForEach(tasks, id: \.self) { value in
                                if (tasks.firstIndex(of: value) == tasks.count-1) {
                                    
                                } else {
                                    if isCompletedArray[(tasks.firstIndex(of: value))!] {
                                        fullCircleAndRectangle(completedTasks: completedTasks, text: value)
                                    } else {
                                        emptyCircleandRectangle(completedTasks: completedTasks, text: value)
                                    }
                                }
                            }
                            if tasks.count > 0 {
                                
                                if isCompletedArray[ (tasks.firstIndex(of: tasks[tasks.count-1])!) ] {
                                    fullCircle(completedTasks: completedTasks, text: tasks[tasks.count-1])
                                } else {
                                    emptyCircle(completedTasks: completedTasks, text: tasks[tasks.count-1])
                                }
                                
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(secondaryColor)
                    .cornerRadius(10)
                    .shadow(color: primaryColor.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    Spacer()
                }
                .padding()
                .background(backgroundColor)
        }
    }
    
    var fullCircleAndRectangle : some View {
        @State var text : String
        return HStack {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(primaryColor)
            Rectangle()
                .fill(completedTasks >= 1 ? primaryColor : secondaryColor)
                .frame(width:20, height: 3)
        }
    }
    
    


    
    @ViewBuilder
    func fullCircleAndRectangle (completedTasks : Int, text : String) -> some View {
        VStack {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
            Text(text)
                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                .font(.caption2)
                .lineLimit(1)
                .padding(.horizontal, 5)
                .frame(width: 100)
        }
        Rectangle()
            .fill(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
            .frame(width: 20, height: 3)
    }
    
    @ViewBuilder
    func emptyCircleandRectangle (completedTasks : Int, text : String) -> some View {
        VStack {
            Circle()
                .stroke(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0), lineWidth: 2)
                .background(Color.white)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    if let index = isCompletedArray.firstIndex(of: false) {
                        isCompletedArray[index].toggle()
                    }
                        
                }
                
            
            Text(text)
                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                .font(.caption2)
                .lineLimit(1)
                .padding(.horizontal, 5)
                .frame(width: 100)
        }
        Rectangle()
        
            .fill(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
            .frame(width: 20, height: 3)
    }
    
    @ViewBuilder
    func emptyCircle (completedTasks : Int, text : String) -> some View {
        VStack {
            Circle()
                .stroke(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0), lineWidth: 2)
                .background(Color.white)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    if let index = isCompletedArray.firstIndex(of: false) {
                        isCompletedArray[index].toggle()
                    }
                        
                }
                
                
            
            Text(text)
                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                .font(.caption2)
                .lineLimit(1)
                .padding(.horizontal, 5)
                .frame(width: 100)
        }
    }
    
    @ViewBuilder
    func fullCircle (completedTasks : Int, text : String) -> some View {
        VStack {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                .onTapGesture {
                    if let index = isCompletedArray.firstIndex(of: false) {
                        isCompletedArray[index].toggle()
                    }
                        
                }
                
                
            
            Text(text)
                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                .font(.caption2)
                .lineLimit(1)
                .padding(.horizontal, 5)
                .frame(width: 100)
        }
    }
}



