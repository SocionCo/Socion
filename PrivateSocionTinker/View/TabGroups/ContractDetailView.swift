import SwiftUI

struct ContractDetailView: View {
    let backgroundColor = Color(.sRGB, red: 0.93, green: 0.96, blue: 0.93, opacity: 1.0)
    let primaryColor = Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0)
    let secondaryColor = Color(.white)
    @EnvironmentObject var userViewModel : UserViewModel
    @State var newTask: String = ""
    @State var contractID: String
    @Environment(\.dismiss) private var dismiss
    
    var currentIndex : Int {
        userViewModel.user.contracts.firstIndex(where: {$0.id == contractID}) ?? 0
    }
    
    var completedTasks : Int {
        userViewModel.user.contracts[currentIndex].isCompletedArray.filter{$0}.count
    }
    
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            ScrollView {
                    
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
                                    Text(userViewModel.user.contracts[currentIndex].name)
                                        .font(.subheadline)
                                        .foregroundColor(primaryColor)
                                }
                                
                                HStack {
                                    Text("Company:")
                                        .font(.headline)
                                        .foregroundColor(primaryColor)
                                    Spacer()
                                    Text(userViewModel.user.contracts[currentIndex].company)
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
                                    Text(Contract.dateToStringForPresentation(date: userViewModel.user.contracts[currentIndex].dueDate) ?? "None")
                                        .font(.subheadline)
                                        .foregroundColor(primaryColor)
                                }
                                
                                HStack {
                                    Text("Amount:")
                                        .font(.headline)
                                        .foregroundColor(primaryColor)
                                    Spacer()
                                    Text("$\(userViewModel.user.contracts[currentIndex].rate ?? 0.0, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(primaryColor)
                                }
                                
                                HStack {
                                    Text("Status:")
                                        .font(.headline)
                                        .foregroundColor(primaryColor)
                                    Spacer()
                                    Text(userViewModel.user.contracts[currentIndex].status.rawValue)
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
                    Image(systemName: "chevron.backward").foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                }
            }
        }.navigationBarBackButtonHidden(true)
            .refreshable {
                print(userViewModel.user.contracts[0].tasks)
                print(userViewModel.user.contracts[currentIndex].tasks)
            }
        
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
                            userViewModel.addTaskToContract(task: newTask, contract: userViewModel.user.contracts[currentIndex])
                            newTask = ""
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(primaryColor)
                                .font(.title)
                        }).disabled(userViewModel.user.contracts[currentIndex].tasks.count > 5)
                    }
                    
                    ForEach(userViewModel.user.contracts[currentIndex].tasks, id: \.self) { task in
                        HStack {
                            Text(task)
                                .font(.headline)
                                .foregroundColor(primaryColor)
                                .strikethrough(userViewModel.isTaskCompleted(task: task, contract: userViewModel.user.contracts[currentIndex]))
                            
                            Spacer()
                            Button(action: {
                                userViewModel.removeTaskfromContract(task: task, contract: userViewModel.user.contracts[currentIndex])
                                
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
                        ForEach(userViewModel.user.contracts[currentIndex].tasks.indices, id: \.self) { index in
                            if index < userViewModel.user.contracts[currentIndex].tasks.count - 1 {
                                if (userViewModel.user.contracts[currentIndex].isCompletedArray[index]) {
                                    fullCircleAndRectangle(completedTasks: completedTasks, text: userViewModel.user.contracts[currentIndex].tasks[index]).onTapGesture {toggleOnTap(index: index)}
                                    
                                } else {
                                    emptyCircleandRectangle(completedTasks: completedTasks, text: userViewModel.user.contracts[currentIndex].tasks[index]).onTapGesture {toggleOnTap(index: index)}
                                }
                                
                            } else {
                                if userViewModel.user.contracts[currentIndex].isCompletedArray[index] {
                                    fullCircle(completedTasks: completedTasks, text: userViewModel.user.contracts[currentIndex].tasks[index]).onTapGesture {toggleOnTap(index: index)}
                                } else {
                                    emptyCircle(completedTasks: completedTasks, text: userViewModel.user.contracts[currentIndex].tasks[index]).onTapGesture
                                    {toggleOnTap(index: index)}
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
    }
    
    func toggleOnTap(index : Int) -> Void {
        userViewModel.toggleTask(task:userViewModel.user.contracts[currentIndex].tasks[index] , contract: userViewModel.user.contracts[currentIndex])
    }
    
    var fullCircleAndRectangle : some View {
        @State var text : String
        return HStack {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(primaryColor)
            Rectangle()
                .fill(primaryColor)
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
                
                
                
            
            Text(text)
                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                .font(.caption2)
                .lineLimit(1)
                .padding(.horizontal, 5)
                .frame(width: 100)
        }
    }
}



