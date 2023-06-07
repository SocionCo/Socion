// Test
import SwiftUI

struct TalentManagerContractListView: View {
    @State var searchText = ""
    @EnvironmentObject private var userViewModel : UserViewModel
    @ObservedObject var agencyViewModel : AgencyViewModel
    @State var editSheet = false
    @State var addSheet = false
    @State var tempCompanyName : String = ""
    @State var tempStatus : Contract.Progress = .notStarted
    @State var tempName : String = ""
    @State var tempRate : Double = 0
    @State var tempPostLink : String = ""
    @State var tempDueDate : Date = Date()
    @State var tempNotes : String = ""
    @State var tempAttachments : [String] = []
    @State var tempApprovals : [Contract.Approval] = []
    @State var tempApprovalNotes : [String] = []
    @State var tempDrafts : [String] = []
    @State var tempPaymentStatus : Contract.PaymentProgress = .notPaid
    @State var tempInfluencer = User()
    @State var tempTasks : [String] = []
    @State var tempCompleted : [Bool] = []
    @State var tempInfluencerAssigned : String = ""
    @State var contracts : [Contract] = []
    @EnvironmentObject var authentication : Authentication
    @State var currentlyEditing : Contract?
    @State var formSubmittable : Bool = false
    @State var includeDate : Bool = false
    @State var refresh: Bool = false
    @State var greenColor = Color(red: 183/255, green: 215/255, blue: 181/255)
    @State var isDeleteAlertPresented = false
    let primaryColor = Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0)
    let lightGreen = Color(red: 190/255, green: 225/255, blue: 190/255)
    
    
    
    var submitFormDisabeled : Bool {
        tempCompanyName == "" || tempName == ""
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(agencyViewModel.getAgencyName())
                    .frame(width: 700, height: 80)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                    .background(greenColor)
                
                SearchBar(searchText: $searchText)
                
            getAgencyList(agencyViewModel.getContractsForManager(talentManager: userViewModel.user, getCompletedContracts: false).sorted(by: sorterForDates))
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Edit") {
                        ForEach(agencyViewModel.getContractsForManager(talentManager: userViewModel.user, getCompletedContracts: false), id: \.self) { contract in
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
                
            }.foregroundColor(.white)
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
            agencyViewModel.editContractAsAgency(contract: contract, company: tempCompanyName, influencer: tempName, status: tempStatus, dueDate: useDate, rate: useRate, paymentStatus: tempPaymentStatus, postLink: usePostLink, tasks: tempTasks, isCompleted: tempCompleted, influencerAssignedToContract: tempInfluencerAssigned, attachments: tempAttachments, notes: tempNotes, approvals: tempApprovals, drafts: tempDrafts, approvalNotes: tempApprovalNotes)
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
        tempCompleted = []
        tempPaymentStatus = .notPaid
        currentlyEditing = nil
        formSubmittable = false
        tempInfluencer = User()
        tempInfluencerAssigned = ""
        tempTasks = []
        tempAttachments = []
        tempNotes = ""
        tempApprovals = []
        tempDrafts = []
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
        
        
        agencyViewModel.addContractToInfluencer(contract: contractToAdd, influencerID: tempInfluencer.id)
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
                    addSheet.toggle()
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
                    HStack {
                        Menu {
                                Picker(selection: $tempInfluencer, label: EmptyView()) {
                                    ForEach(agencyViewModel.getInfluencersForManager(talentManager: userViewModel.user)) {influencer in
                                        Text(influencer.getFullName()).tag(influencer)
                                    }
                                    Text("None").tag(User())
                                }
                            } label: {
                            if tempInfluencer == User() {
                                Text("Assign a creator")
                                    .foregroundColor(DetailViewConstants.lightGrey)
                                    .fontWeight(.bold)
                                    .font(.title2)
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10, height: 10)
                                    .padding(20)
                                    .foregroundColor(.green)
                                    .background(DetailViewConstants.lightGreenBackground)
                                    .cornerRadius(50)
                            } else {
                                Text("Assign a creator")
                                    .foregroundColor(DetailViewConstants.lightGrey)
                                    .fontWeight(.bold)
                                    .font(.title2)
                                Image(uiImage: tempInfluencer.profilePicture)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
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
                    HStack {
                        Menu {
                                Picker(selection: $tempInfluencer, label: EmptyView()) {
                                    ForEach(agencyViewModel.getInfluencersForManager(talentManager: userViewModel.user)) {influencer in
                                        Text(influencer.getFullName()).tag(influencer)
                                    }
                                    Text("None").tag(User())
                                }
                            } label: {
                            if tempInfluencer == User() {
                                Text("Assign a creator")
                                    .foregroundColor(DetailViewConstants.lightGrey)
                                    .fontWeight(.bold)
                                    .font(.title2)
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10, height: 10)
                                    .padding(20)
                                    .foregroundColor(.green)
                                    .background(DetailViewConstants.lightGreenBackground)
                                    .cornerRadius(50)
                            } else {
                                Text("Assign a creator")
                                    .foregroundColor(DetailViewConstants.lightGrey)
                                    .fontWeight(.bold)
                                    .font(.title2)
                                Image(uiImage: tempInfluencer.profilePicture)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
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
    
    func getAgencyList (_ contracts : [Contract]) -> some View {
        ZStack {
            Color(hex: 0xeceef5)
                .ignoresSafeArea()
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(contracts) { contract in
                        NavigationLink {
                            if let owner = userViewModel.agencyViewModel.getOwnerOfContract(contract: contract) {
                                AgentContractDetailView(userID: owner.id, contractID: contract.id)
                            } else {
                                ErrorView()
                            }
                        } label: {
                            HStack {
                                if let owner = userViewModel.agencyViewModel.getOwnerOfContract(contract: contract) {
                                    Image(uiImage: owner.profilePicture)
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .shadow(radius: 4)
                                    
                                } else {
                                    Text("Error")
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(contract.name)
                                        .font(.title3)
                                        .bold()
                                        .padding(1)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                    if let owner = userViewModel.agencyViewModel.getOwnerOfContract(contract: contract) {
                                        Text(owner.getFullName())
                                            .padding(1)
                                            .font(.body)
                                    } else {
                                        Text("Error")
                                            .padding(1)
                                            .font(.body)
                                    }
                                    Text(contract.getStatus().rawValue)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(3)
                                        .background(Contract.statusColor(contract: contract))
                                        .cornerRadius(20)
                                }
                                .padding(.leading, 5)
                                .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(10)
                            .background(Color.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 0) //Edit this line for spacing
                            .cornerRadius(20)
                        }
                    }
                }.padding(.top, 10)
            }
        }
    }
    
}



