import SwiftUI

struct AgentContractDetailView: View {
    let backgroundColor = Color(.white)
    let primaryColor = Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0)
    let secondaryColor = Color(.sRGB, red: 0.93, green: 0.96, blue: 0.93, opacity: 1.0)
    @EnvironmentObject var userViewModel : UserViewModel
    @State var userID : String
    @State var newTask: String = ""
    @State var contractID: String
    @Environment(\.dismiss) private var dismiss
    @State var showPhotoLibrary : Bool = false
    @State var image : UIImage = UIImage()
    @State private var isDeleteAlertPresented = false
    @State private var isPaidAlertPresented = false
    
    var userIndex : Int {
        return userViewModel.agencyViewModel.agency.influencers.firstIndex(where: {$0.id == userID})!
    }
    
    var currentIndex : Int {
        userViewModel.agencyViewModel.agency.influencers[userIndex].contracts.firstIndex(where: {$0.id == contractID}) ?? 0
    }
    
    var completedTasks : Int {
        userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].isCompletedArray.filter{$0}.count
    }
    
    var taskGap : Int {
        let taskAmount = userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks.count
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
        userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex]
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
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
                    assignView
                    taskMenu.background(backgroundColor)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Attachments")
                            .font(.title2)
                            .foregroundColor(DetailViewConstants.lightGrey)
                            .fontWeight(.bold)
                        Text("Campaign has no attachments to show")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            isDeleteAlertPresented = true
                        }) {
                            Text("Delete")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(red: 245/255, green: 172/255, blue: 172/255))
                                .cornerRadius(10)
                            }
                        Button(action: {
                            isPaidAlertPresented = true
                        }) {
                            Text("Paid")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(red: 172/255, green: 245/255, blue: 183/255))
                                .cornerRadius(10)
                            }
                        Spacer()
                        }
                    }
                }
                .padding()
                .background(backgroundColor)
            }
        .alert(title: "Are you sure you want to delete this campaign?", message: "This action is permanent. You will not be able to recover campaigns that are deleted.",
               primaryButton: CustomAlertButton(title: "Yes", action: {userViewModel.agencyViewModel.deleteContractForAgency(contract: contract)}),
                   secondaryButton: CustomAlertButton(title: "No", action: {  }),
                   isPresented: $isDeleteAlertPresented)
        .alert(title: "Are you sure you want to mark this campaign as paid?", message: "If you wish to access past campaigns, they are accessible in the agency settings section of the agency dashboard. ",
                   primaryButton: CustomAlertButton(title: "Yes", action: {userViewModel.agencyViewModel.updateContractPaymentStatus(userID: userID, contract: contract, newPaymentStatus: .paid)}),
                   secondaryButton: CustomAlertButton(title: "No", action: { }),
                   isPresented: $isPaidAlertPresented)
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
                print(userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[0].tasks)
                print(userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks)
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
                    .font(.title2)
                    .foregroundColor(DetailViewConstants.lightGrey)
                    .fontWeight(.bold)
                
                VStack{
                    HStack {
                        TextField("New task", text: $newTask)
                            .padding(.horizontal)
                            .foregroundColor(primaryColor)
                            .frame(height: 44)
                            .cornerRadius(10)
                        
                        Button(action: {
                            userViewModel.agencyViewModel.addTaskToContract(id: userID, task: newTask, contract: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex])
                            newTask = ""
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(primaryColor)
                                .font(.title)
                        }).disabled(userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks.count > 3)
                    }
                    
                    ForEach(userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks, id: \.self) { task in
                        HStack {
                            Text(task)
                                .font(.headline)
                                .foregroundColor(primaryColor)
                                .strikethrough(userViewModel.agencyViewModel.isTaskCompleted(task: task, contract: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex]))
                            
                            Spacer()
                            Button(action: {
                                userViewModel.agencyViewModel.toggleTask(id: userID, task: task, contract: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex])
                                
                            }, label: {
                                if !userViewModel.agencyViewModel.isTaskCompleted(task: task, contract: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex]) {
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
                                userViewModel.agencyViewModel.removeTaskfromContract(id: userID, task: task, contract: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex])
                                
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
                .font(.custom("Inter-Thin", size: 25))
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
                    ForEach(userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks.indices, id: \.self) { index in
                        if index < userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks.count - 1 {
                            if (userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].isCompletedArray[index]) {
                                fullCircleAndRectangle(completedTasks: completedTasks, text: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks[index]).onTapGesture {toggleOnTap(index: index)}
                                
                            } else {
                                emptyCircleandRectangle(completedTasks: completedTasks, text: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks[index]).onTapGesture {toggleOnTap(index: index)}
                            }
                            
                        } else {
                            if userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].isCompletedArray[index] {
                                fullCircle(completedTasks: completedTasks, text: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks[index]).onTapGesture {toggleOnTap(index: index)}
                            } else {
                                emptyCircle(completedTasks: completedTasks, text: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks[index]).onTapGesture
                                {toggleOnTap(index: index)}
                            }
                        }
                    }
                    Spacer()
                }
                HStack (spacing: 0) {
                    Spacer()
                    ForEach(userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks.indices, id: \.self) { index in
                        if index == userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks.count - 1 {
                            Text(userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks[index])
                                .foregroundColor(Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0))
                                .font(.caption2)
                                .lineLimit(1)
                                .frame(width: 60)
                        } else {
                            Text(userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks[index])
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
    
    var assignView : some View {
        VStack (alignment: .leading, spacing: 20) {
            Text("Assigned Influencers")
                .foregroundColor(DetailViewConstants.lightGrey)
                .font(.title2)
                .fontWeight(.bold)
            HStack(spacing: 15) {
                userViewModel.agencyViewModel.agency.influencers[userIndex].profilePicture
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .foregroundColor(DetailViewConstants.lightGreenBackground)
                    .help("\(userViewModel.agencyViewModel.agency.influencers[userIndex].getFullName())")
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
                    .padding(20)
                    .foregroundColor(.green)
                    .background(DetailViewConstants.lightGreenBackground)
                    .cornerRadius(50)
            }
            
        }
    }
    
    func toggleOnTap(index : Int) -> Void {
        userViewModel.agencyViewModel.toggleTask(id: userID, task:userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].tasks[index] , contract: userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex])
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



