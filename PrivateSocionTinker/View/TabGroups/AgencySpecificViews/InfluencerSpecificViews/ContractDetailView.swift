import SwiftUI

struct ContractDetailView: View {
    let backgroundColor = Color(.white)
    let primaryColor = Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0)
    let secondaryColor = Color(.sRGB, red: 0.93, green: 0.96, blue: 0.93, opacity: 1.0)
    @EnvironmentObject var userViewModel : UserViewModel
    @State var newTask: String = ""
    @State var contractID: String
    @Environment(\.dismiss) private var dismiss
    @State var showPhotoLibrary : Bool = false
    @State var image : UIImage = UIImage()
    @State var isExpanded : Bool = false
    
    var currentIndex : Int {
        userViewModel.user.contracts.firstIndex(where: {$0.id == contractID})!
    }
    
    var completedTasks : Int {
        userViewModel.user.contracts[currentIndex].isCompletedArray.filter{$0}.count
    }
    
    var taskGap : Int {
        let taskAmount = userViewModel.user.contracts[currentIndex].tasks.count
        if taskAmount == 4 {
            return 50
        } else if taskAmount == 3 {
            return 70
        } else if taskAmount == 2 {
            return 90
        } else {
            return 40
        }
        
    }
    
    var contract : Contract {
        userViewModel.user.contracts[currentIndex]
    }
    
    var body: some View {
        VStack (spacing: 0) {
            taskBar.background(backgroundColor).padding(.bottom,15)
            Divider()
                .frame(height: 1)
                .background(primaryColor)
                .padding(0)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Campaign Details")
                        .foregroundColor(DetailViewConstants.lightGrey)
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        HStack {
                            Text("Company:")
                                .font(.headline)
                                .foregroundColor(primaryColor)
                                .fontWeight(.bold)
                            Spacer()
                            Text(contract.company)
                                .font(.title3)
                                .foregroundColor(primaryColor)
                        }
                        Text("Notes:")
                            .font(.headline)
                            .foregroundColor(primaryColor)
                            .fontWeight(.bold)
                        if contract.notes == "" || contract.notes == " " {
                            Text("No notes provided.")
                                .foregroundColor(primaryColor)
                        } else {
                            ExpandableText(contract.notes, lineLimit: 3, fontColor: primaryColor)
                        }
                    }
                    .padding()
                    .background(DetailViewConstants.lightGreenBackground)
                    .cornerRadius(10)
                    taskMenu.background(backgroundColor)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Attachments")
                            .font(.title2)
                            .foregroundColor(DetailViewConstants.lightGrey)
                            .fontWeight(.bold)
                        
                    }
                }
                .padding()
                .background(backgroundColor)
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward").foregroundColor(DetailViewConstants.lightGrey)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(DetailViewConstants.lightGrey)
                }
            }
        }.navigationBarBackButtonHidden(true)
            .refreshable {
                print(userViewModel.user.contracts[0].tasks)
                print(userViewModel.user.contracts[currentIndex].tasks)
            }
            .onTapGesture {
                dismissKeyboard()
            }
        
    }
    
    
    var taskMenu : some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                Text("Tasks")
                    .font(.largeTitle)
                    .foregroundColor(primaryColor)
                    .fontWeight(.bold)
                
                VStack{
                    HStack {
                        TextField("New task", text: $newTask)
                            .padding(.horizontal)
                            .foregroundColor(primaryColor)
                            .frame(height: 44)
                            .cornerRadius(10)
                        
                        Button(action: {
                            userViewModel.addTaskToContract(task: newTask, contract: userViewModel.user.contracts[currentIndex])
                            newTask = ""
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(primaryColor)
                                .font(.title)
                        }).disabled(userViewModel.user.contracts[currentIndex].tasks.count > 3)
                    }
                    
                    ForEach(userViewModel.user.contracts[currentIndex].tasks, id: \.self) { task in
                        HStack {
                            Text(task)
                                .font(.headline)
                                .foregroundColor(primaryColor)
                                .strikethrough(userViewModel.isTaskCompleted(task: task, contract: userViewModel.user.contracts[currentIndex]))
                            
                            Spacer()
                            Button(action: {
                                userViewModel.toggleTask(task: task, contract: userViewModel.user.contracts[currentIndex])
                                
                            }, label: {
                                if !userViewModel.isTaskCompleted(task: task, contract: userViewModel.user.contracts[currentIndex]) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(primaryColor)
                                        .font(.title)
                                } else {
                                    Image(systemName: "x.circle.fill")
                                        .foregroundColor(primaryColor)
                                        .font(.title)
                                }
                            })
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
                .cornerRadius(10)
                .padding(10)
                
            }
            .background(backgroundColor)
        }
    }
    
    private var statusText : some View {
        Text(contract.getStatus().rawValue)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .frame(width: 110, height: 25)
            .background(Contract.statusColor(contract: contract))
            .cornerRadius(20)
    }
    
    
    private var priceText : some View {
        Text("$\(contract.rate!, specifier: "%.2f")")
            .foregroundColor(.green)
            .fontWeight(.bold)
            .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
            .ignoresSafeArea()
            .background(DetailViewConstants.rateBackgroundGreen)
            .cornerRadius(20)
    }
        
    var taskBar : some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(contract.name)
                .font(.custom("Inter-Bold", size: 25))
                .padding()
                .fontWeight(.heavy)
            
            HStack {
                Spacer()
                if (contract.rate != nil) {
                    priceText
                    Spacer()
                }
                if (contract.dueDate != nil) {
                    let contractString : String = Contract.cutDownPresentationDate(date:  Contract.dateToStringForPresentation(date: contract.dueDate!)!)
                    Text("Due: \(contractString)")
                        .foregroundColor(DetailViewConstants.lightGrey)
                        .fontWeight(.bold)
                    Spacer()
                }
                statusText
                Spacer()
            }.padding(.bottom,15)
            
            VStack{
                HStack(spacing: 0) {
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
                    }
                    Spacer()
                }
                HStack (spacing: 0) {
                    Spacer()
                    ForEach(userViewModel.user.contracts[currentIndex].tasks.indices, id: \.self) { index in
                        if index == userViewModel.user.contracts[currentIndex].tasks.count - 1 {
                            Text(userViewModel.user.contracts[currentIndex].tasks[index])
                                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                                .font(.caption2)
                                .lineLimit(1)
                                .frame(width: 60)
                        } else {
                            Text(userViewModel.user.contracts[currentIndex].tasks[index])
                                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                                .font(.caption2)
                                .lineLimit(1)
                                .frame(width: 60)
                                .padding(.trailing, CGFloat(taskGap - 30))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    
        
        func toggleOnTap(index : Int) -> Void {
            userViewModel.toggleTask(task:userViewModel.user.contracts[currentIndex].tasks[index] , contract: userViewModel.user.contracts[currentIndex])
        }
    
        
        @ViewBuilder
        func fullCircleAndRectangle (completedTasks : Int, text : String) -> some View {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
            Rectangle()
                .fill(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                .frame(width: CGFloat(taskGap), height: 3)
        }
        
        @ViewBuilder
        func emptyCircleandRectangle (completedTasks : Int, text : String) -> some View {
            Circle()
                .stroke(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0), lineWidth: 2)
                .background(Color.white)
                .frame(width: 30, height: 30)
            
            Rectangle()
                .fill(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                .frame(width: CGFloat(taskGap), height: 3)
        }
        
        @ViewBuilder
        func emptyCircle (completedTasks : Int, text : String) -> some View {
            Circle()
                .stroke(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0), lineWidth: 2)
                .background(Color.white)
                .frame(width: 30, height: 30)
        }
        
        @ViewBuilder
        func fullCircle (completedTasks : Int, text : String) -> some View {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
            
        }
        
        func dismissKeyboard () {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    
struct DetailViewConstants {
    static let rateBackgroundGreen : Color = Color(red: 236/255, green: 247/255, blue: 242/255)
    
    static let lightGrey : Color = Color(red: 172/255, green: 173/255, blue: 172/255)
    
    static let lightGreenBackground : Color = Color(red: 236/255, green: 247/255, blue: 242/255)
}

