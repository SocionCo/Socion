// Test
import SwiftUI

struct ContractListView: View {
    @State var searchText = ""
    @EnvironmentObject private var userViewModel : UserViewModel
    @State var editSheet = false
    @State var addSheet = false
    @State var tempCompanyName : String = ""
    @State var tempStatus : Contract.Progress = .notStarted
    @State var tempName : String = ""
    @State var tempRate : Double = 0
    @State var tempPostLink : String = ""
    @State var tempDueDate : Date = Date()
    @State var tempInfluencerAssigned : String = ""
    @State var tempPaymentStatus : Contract.PaymentProgress = .notPaid
    @State var tempNotes : String = ""
    @State var tempAttachments : [String] = []
    @State var tempApprovals : [Contract.Approval] = []
    @State var tempApprovalNotes : [String] = []
    @State var tempDrafts : [String] = []
    @EnvironmentObject var authentication : Authentication
    @State var currentlyEditing : Contract?
    @State var formSubmittable : Bool = false
    @State var includeDate : Bool = false
    @State var tempTasks : [String] = []
    @State var tempCompleted : [Bool] = []
    @State var greenColor = Color(red: 183/255, green: 215/255, blue: 181/255)
    @State var refresh = false
    let lightGreen = Color(red: 190/255, green: 225/255, blue: 190/255)
    let primaryColor = Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0)
    @State var isDeleteAlertPresented = false
    
    var submitFormDisabeled : Bool {
        tempCompanyName == "" || tempName == ""
    }
    
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .center, spacing: 0) {
                Group {
                    Text(userViewModel.getName())
                        .foregroundColor(.white)
                        .frame(width: 700, height: 80)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.5)
                }
                .background(.green)
                
                SearchBar(searchText: $searchText)
                
                
                List() {
                    ForEach (userViewModel.user.contracts.sorted(by: sorterForDates), id: \.self) { campaign in
                        NavigationLink {
                            ContractDetailView(contractID: campaign.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(campaign.name)
                                    .font(.title3)
                                    .lineLimit(1)
                                    .bold()
                                    .padding(.bottom, 5.0)
                                    .foregroundColor(.black)
                                HStack (spacing: 10) {
                                    Text("Campaign Status")
                                        .foregroundColor(.gray)
                                        .bold()
                                        .listRowSeparator(.hidden)
                                    Text(campaign.getStatus().rawValue)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .frame(width: 110, height: 25)
                                        .background(Contract.statusColor(contract: campaign))
                                        .cornerRadius(20)
                                }
                                HStack (spacing: 20) {
                                    Text("Payment Status:")
                                        .listRowSeparator(.hidden)
                                        .foregroundColor(.gray)
                                        .bold()
                                    Text(campaign.paymentStatus.rawValue)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .frame(width: 110, height: 25)
                                        .background(Contract.paymentStatusColor(contract: campaign))
                                        .cornerRadius(20)
                                }
                            }
                        }.listRowBackground (
                            RoundedRectangle(cornerRadius: 17)
                                .fill(Color.white)
                                .padding(2))
                    }
                }.listStyle(.automatic)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Edit") {
                        ForEach(userViewModel.user.contracts) { contract in
                            Button(contract.name) {
                                tempStatus = contract.getStatus()
                                tempName = contract.name
                                tempCompanyName = contract.company
                                tempTasks = contract.tasks
                                tempCompleted = contract.isCompletedArray
                                currentlyEditing = contract
                                tempPaymentStatus = contract.paymentStatus
                                tempInfluencerAssigned = contract.influencerAssignedToContract ?? ""
                                if contract.rate != nil {
                                    tempRate = contract.rate!
                                }
                                if contract.dueDate != nil {
                                    tempDueDate = contract.dueDate!
                                }
                                tempNotes = contract.notes
                                tempAttachments = contract.attachments
                                tempApprovals = contract.approvals
                                tempDrafts = contract.drafts
                                tempApprovalNotes = contract.approvalNotes
                                editSheet = true
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
                
            }
            .foregroundColor(.white)
        }
        .refreshable {
            refresh.toggle()
        }
        .background(greenColor)
        .sheet(isPresented: $editSheet, onDismiss: setValues) {
            editSheetView
        }
        .interactiveDismissDisabled(true)
        .sheet(isPresented: $addSheet, onDismiss: addNew) {
            addSheetView
        }
    }
    
    func sorterForDates(this: Contract, that: Contract) -> Bool {
        if (this.dueDate == nil && that.dueDate != nil) {
            return false
        }
        if (this.dueDate != nil && that.dueDate == nil) {
            return true
        }
        if (this.dueDate == nil && that.dueDate == nil) {
            return false
        }
        return this.dueDate! < that.dueDate!
    }
    
    func setValues () {
        if (formSubmittable == false) {
            return
        }
        if let contract = currentlyEditing {
            var useRate : Double?
            var useDate : String?
            var usePostLink : String?
            if (tempRate == 0) {
                useRate = nil
            } else {
                useRate = Double(tempRate)
            }
            if (!includeDate) {
                useDate = nil
            } else {
                useDate = Contract.dateToStringForStorage(date: tempDueDate)
            }
            if (tempPostLink == "") {
                usePostLink = nil
            } else {
                usePostLink = tempPostLink
            }
            
            print("Updating status to \(tempStatus.rawValue)")
            userViewModel.editContract(contract: contract, company: tempCompanyName, influencer: tempName, status: tempStatus, dueDate: useDate, rate: useRate, paymentStatus: tempPaymentStatus, postLink: usePostLink, tasks: tempTasks, isCompleted: tempCompleted, influencerAssignedToContract: tempInfluencerAssigned, attachments: tempAttachments, notes: tempNotes, approvals: tempApprovals, drafts: tempDrafts, approvalNotes: tempApprovalNotes)
            print("Campaign status is:: \(contract.getStatus().rawValue)")
            resetValues()
        }
    }
    
    func resetValues () {
        tempRate = 0
        tempCompanyName = ""
        tempName = ""
        tempStatus = .inProgress
        tempDueDate = Date()
        tempPostLink = ""
        tempPaymentStatus = .notPaid
        tempInfluencerAssigned = ""
        currentlyEditing = nil
        formSubmittable = false
        tempTasks = []
        tempCompleted = []
        tempAttachments = []
        tempNotes = ""
        tempDrafts = []
        tempApprovals = []
        tempApprovalNotes = []
        
    }
    
    func addNew () {
        if formSubmittable == false {
            return
        }
        var useRate : Double?
        var useDate : String?
        var usePostLink : String?
        if (tempRate == 0) {
            useRate = nil
        } else {
            useRate = Double(tempRate)
        }
        if (!includeDate) {
            useDate = nil
        } else {
            useDate = Contract.dateToStringForStorage(date: tempDueDate)
        }
        if (tempPostLink == "") {
            usePostLink = nil
        } else {
            usePostLink = tempPostLink
        }
        
        let contractToAdd = Contract(id: UUID().uuidString, company: tempCompanyName, status: tempStatus, influencer: tempName, paymentStatus: tempPaymentStatus, postLink: usePostLink, dueDate: Contract.stringToDateForStorage(stringDate: useDate), rate: useRate, tasks: tempTasks, isCompletedArray: tempCompleted, influencerAssignedToContract: tempInfluencerAssigned, attachments: tempAttachments, notes: tempNotes, approvals: tempApprovals, drafts: tempDrafts, approvalNotes: tempApprovalNotes)
        
        userViewModel.addContract(contract: contractToAdd)
        resetValues()
    }
    
    
    struct SearchBar: View {
        @Binding var searchText: String
        
        var body: some View {
            HStack {
                TextField("Search", text: $searchText)
                    .padding(8)
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(20)
                    .foregroundColor(.gray)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                        }
                    )
                withAnimation {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                    .opacity(searchText.isEmpty ? 0 : 1)
                }
            }
            .padding(.horizontal, 10)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 5)
        }
    }
    
    var addSheetView : some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    if addSheet {addSheet.toggle()}
                    if editSheet {editSheet.toggle()}
                    resetValues()
                } label: {
                    Image(systemName: "xmark")
                        .padding(.trailing, 20)
                        .foregroundColor(primaryColor)
                }
            }
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Spacer()
                    Text("Add Campaign")
                        .font(.largeTitle)
                        .foregroundColor(primaryColor)
                    Spacer()
                }
                Divider()
                    .foregroundColor(primaryColor)
                HStack {
                    Text("Campaign Title")
                        .foregroundColor(DetailViewConstants.lightGrey)
                        .fontWeight(.bold)
                        .font(.title2)
                    + Text("*")
                        .foregroundColor(primaryColor)
                        .fontWeight(.bold)
                        .font(.title2)
                    Spacer()
                }
                TextField("", text: $tempName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(primaryColor, lineWidth: 3)
                    )
                    .padding(.horizontal)
                VStack {
                    HStack {
                        Text("Payment")
                            .foregroundColor(DetailViewConstants.lightGrey)
                            .fontWeight(.bold)
                            .font(.title2)
                        + Text("*")
                            .foregroundColor(primaryColor)
                            .fontWeight(.bold)
                            .font(.title2)
                        TextField("$", value: $tempRate, formatter: NumberFormatter())
                            .keyboardType(UIKeyboardType.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(primaryColor, lineWidth: 3)
                            )
                            .frame(width: 110)
                    }
                    HStack {
                        Text("Deadline")
                            .foregroundColor(DetailViewConstants.lightGrey)
                            .fontWeight(.bold)
                            .font(.title2)
                            
                        + Text("*")
                            .foregroundColor(primaryColor)
                            .fontWeight(.bold)
                            .font(.title2)
                            
                        DatePicker(selection: $tempDueDate, in: Date.now..., displayedComponents: .date) {
                            Text("")
                        }
                        .tint(primaryColor)
                        .frame(width: 110)
                    }
                    HStack {
                        Text("Company")
                            .foregroundColor(DetailViewConstants.lightGrey)
                            .fontWeight(.bold)
                            .font(.title2)
                        + Text("*")
                            .foregroundColor(primaryColor)
                            .fontWeight(.bold)
                            .font(.title2)
                        TextField("", text: $tempCompanyName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(primaryColor, lineWidth: 3)
                            )
                            .frame(width: 110)
                    }
                }
                Text("Notes")
                    .foregroundColor(DetailViewConstants.lightGrey)
                    .fontWeight(.bold)
                    .font(.title2)
                TextField("", text: $tempNotes, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(primaryColor.opacity(0.5), lineWidth: 2)
                    )
                
                
            }
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    HStack {
                        Button {
                            formSubmittable = true
                            addSheet = false
                            
                        } label: {
                            Text("Submit")
                                .foregroundColor(primaryColor)
                                .font(.largeTitle)
                                .frame(width: 300)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(DetailViewConstants.lightGreenBackground)
                                )
                            
                        }.disabled(submitFormDisabeled)
                    }
                    Text("*Required to create a campaign")
                        .foregroundColor(primaryColor)
                        .bold()
                }
                .padding(.top,40)
                Spacer()
            }
        }
        .padding()
    }
    
    var editSheetView : some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    editSheet.toggle()
                    resetValues()
                } label: {
                    Image(systemName: "xmark")
                        .padding(.trailing, 20)
                        .foregroundColor(primaryColor)
                }
            }
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Spacer()
                    Text("Edit Campaign")
                        .font(.largeTitle)
                        .foregroundColor(primaryColor)
                    Spacer()
                }
                Divider()
                    .foregroundColor(primaryColor)
                HStack {
                    Text("Campaign Title")
                        .foregroundColor(DetailViewConstants.lightGrey)
                        .fontWeight(.bold)
                        .font(.title2)
                    + Text("*")
                        .foregroundColor(primaryColor)
                        .fontWeight(.bold)
                        .font(.title2)
                    Spacer()
                }
                TextField("", text: $tempName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(primaryColor.opacity(0.5), lineWidth: 2)
                    )
                    .padding(.horizontal)
                VStack {
                    HStack {
                        Text("Payment")
                            .foregroundColor(DetailViewConstants.lightGrey)
                            .fontWeight(.bold)
                            .font(.title2)
                        + Text("*")
                            .foregroundColor(primaryColor)
                            .fontWeight(.bold)
                            .font(.title2)
                        TextField("$", value: $tempRate, formatter: NumberFormatter())
                            .keyboardType(UIKeyboardType.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(primaryColor.opacity(0.5), lineWidth: 2)
                            )
                            .frame(width: 110)
                    }
                    HStack {
                        Text("Deadline")
                            .foregroundColor(DetailViewConstants.lightGrey)
                            .fontWeight(.bold)
                            .font(.title2)
                            
                        + Text("*")
                            .foregroundColor(primaryColor)
                            .fontWeight(.bold)
                            .font(.title2)
                            
                        DatePicker(selection: $tempDueDate, in: Date.now..., displayedComponents: .date) {
                            Text("")
                        }
                        .tint(primaryColor)
                        .frame(width: 110)
                    }
                    HStack {
                        Text("Company")
                            .foregroundColor(DetailViewConstants.lightGrey)
                            .fontWeight(.bold)
                            .font(.title2)
                        + Text("*")
                            .foregroundColor(primaryColor)
                            .fontWeight(.bold)
                            .font(.title2)
                        TextField("", text: $tempCompanyName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(primaryColor.opacity(0.5), lineWidth: 2)
                            )
                            .frame(width: 110)
                    }
                }
                Text("Notes")
                    .foregroundColor(DetailViewConstants.lightGrey)
                    .fontWeight(.bold)
                    .font(.title2)
                TextField("", text: $tempNotes, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(primaryColor.opacity(0.5), lineWidth: 2)
                    )
                
                
            }
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    HStack {
                        Button {
                            formSubmittable = true
                            editSheet = false
                            
                        } label: {
                            Text("Submit")
                                .foregroundColor(primaryColor)
                                .font(.largeTitle)
                                .frame(width: 150)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(DetailViewConstants.lightGreenBackground)
                                )
                            
                        }.disabled(submitFormDisabeled)
                            Button {
                                if currentlyEditing != nil {
                                    isDeleteAlertPresented = true
                                }
                            } label: {
                                Text("Delete")
                                    .foregroundColor(primaryColor)
                                    .font(.largeTitle)
                                    .frame(width: 150)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(DetailViewConstants.lightRed)
                                    )
                                
                            }
                    }
                    Text("*Required to create a campaign")
                        .foregroundColor(primaryColor)
                        .bold()
                }
                .padding(.top,40)
                Spacer()
            }
        }
        .padding()
        .alert(title: "Are you sure you want to delete this campaign?", message: "This action is permanent. You will not be able to recover campaigns that are deleted.",
                primaryButton: CustomAlertButton(title: "Yes", action: {userViewModel.agencyViewModel.deleteContractForAgency(contract: currentlyEditing!)
                    editSheet = false
        }),
                secondaryButton: CustomAlertButton(title: "No", action: {  }),
                isPresented: $isDeleteAlertPresented)
    }
    
}
