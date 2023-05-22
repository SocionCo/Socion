// Test
import SwiftUI

struct ManagerContractListView: View {
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
    @State var tempMiscellaneous : String = ""
    @State var tempPaymentStatus : Contract.PaymentProgress = .notPaid
    @State var tempInfluencer = User()
    @State var tempInfluencerAssigned : String = ""
    @State var tempTasks : [String] = []
    @State var tempCompleted : [Bool] = []
    @State var contracts : [Contract] = []
    @EnvironmentObject var authentication : Authentication
    @State var currentlyEditing : Contract?
    @State var formSubmittable : Bool = false
    @State var includeDate : Bool = false
    @State var refresh: Bool = false
    @State var greenColor = Color(red: 183/255, green: 215/255, blue: 181/255)
    
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
                
                List {
                    Section {
                        ForEach(agencyViewModel.getContracts(getCompletedContracts: false).sorted(by: sorterForDates), id: \.self) { contract in
                            NavigationLink {
                                if agencyViewModel.getOwnerOfContract(contract: contract) != nil {
                                    AgentContractDetailView(userID: agencyViewModel.getOwnerOfContract(contract: contract)!.id, contractID: contract.id)
                                } else {
                                    ErrorView()
                                }
                            }
                        label: {
                            HStack {
                                VStack (alignment: .leading, spacing: 10) {
                                    Text(contract.company)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(greenColor)
                                    
                                    Text("Influencer: \(agencyViewModel.getOwnerOfContract(contract: contract)?.getFullName() ?? "")")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    Text(contract.getStatus().rawValue)
                                        .font(.title2)
                                        .foregroundColor(Contract.statusColor(contract: contract))
                                    
                                    if let dueDate = contract.dueDate {
                                        if refresh || !refresh {
                                            let dueString = Contract.timeUntilDate(date: dueDate)
                                            Text("Due in: \(dueString!.trimmingCharacters(in: .whitespaces))")
                                                .font(.title2)
                                                .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                                        }
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.black)
                            }
                        }
                        }
                        .onDelete { argument in
                            
                        }
                        .padding(.vertical)
                        
                    }
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            authentication.updateValidation(success: false)
                            userViewModel.logOut()
                        }
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                }
                ToolbarItem {
                    Menu("Manage") {
                        Menu("New Contract") {
                            ForEach(agencyViewModel.getInfluencers(), id: \.self) { influencer in
                                Button(influencer.getFullName()) {
                                    tempInfluencer = influencer
                                    addSheet = true
                                    formSubmittable = true
                                }
                            }
                        }
                        Menu("Delete Contract") {
                            ForEach(agencyViewModel.getContracts(), id: \.self) { contract in
                                Button(contract.company) {
                                    agencyViewModel.deleteContractForAgency(contract: contract)
                                }
                            }
                        }
                        Menu("Edit") {
                            ForEach(agencyViewModel.getContracts(), id: \.self) { contract in
                                Button(contract.company) {
                                    tempStatus = contract.getStatus()
                                    tempName = contract.name
                                    tempCompanyName = contract.company
                                    tempTasks = contract.tasks
                                    tempCompleted = contract.isCompletedArray
                                    tempInfluencerAssigned = contract.influencerAssignedToContract ?? ""
                                    currentlyEditing = contract
                                    tempPaymentStatus = contract.paymentStatus
                                    tempMiscellaneous = contract.miscellaneous
                                    tempNotes = contract.notes
                                    if contract.rate != nil {
                                        tempRate = contract.rate!
                                    }
                                    if contract.dueDate != nil {
                                        tempDueDate = contract.dueDate!
                                    }
                                    editSheet.toggle()
                                }
                            }
                        }
                    }
                }
            }.foregroundColor(.white)
        }.refreshable {
            refresh.toggle()
        }.sheet(isPresented: $editSheet, onDismiss: setValues) {
            VStack {
                Form {
                    Section(header: Text("Campaign Information")) {
                        TextField("Company Name", text: $tempCompanyName)
                        TextField("Campaign Name", text: $tempName)
                        Picker("Status", selection: $tempStatus) {
                            ForEach(Contract.Progress.allCases, id: \.self) {value in
                                Text(value.rawValue)
                            }
                        }
                        TextField("Notes:", text: $tempNotes, axis: .vertical)
                            .lineLimit(2...5)
                        TextField("Miscellaneous", text: $tempMiscellaneous)
                        TextField("Post Link (optional)", text: $tempPostLink)
                        Toggle(isOn: $includeDate) {
                            Text("Campaign has due date")
                        }
                        if (includeDate) {
                            DatePicker(selection: $tempDueDate, in: Date.now..., displayedComponents: .date) {
                                Text("Select a date")
                            }
                        }
                        TextField("Rate (optional)", value: $tempRate, format: .number)
                        Picker("Payment Status", selection: $tempPaymentStatus) {
                            ForEach(Contract.PaymentProgress.allCases, id: \.self) {value in
                                Text(value.rawValue)
                            }
                        }
                    }
                }
                HStack(spacing: 20) {
                    Spacer()
                    Button {
                        formSubmittable = true
                        editSheet = false
                    } label : {
                        Text("Done")
                    } .disabled(submitFormDisabeled)
                    Spacer()
                    Button {
                        resetValues()
                        editSheet = false
                    } label: {
                        Text("Cancel")
                    }
                    Spacer()
                }
            }
        }.interactiveDismissDisabled(true)
            .sheet(isPresented: $addSheet, onDismiss: addNew) {
                HStack{
                    VStack {
                        Form {
                            Section(header: Text("Campaign Information for \(tempInfluencer.getFullName())")) {
                                TextField("Company Name", text: $tempCompanyName)
                                TextField("Campaign Name", text: $tempName)
                                Picker("Status", selection: $tempStatus) {
                                    ForEach(Contract.Progress.allCases, id: \.self) {value in
                                        Text(value.rawValue)
                                    }
                                }
                                TextField("Post Link (optional)", text: $tempPostLink)
                                Toggle(isOn: $includeDate) {
                                    Text("Campaign has due date")
                                }
                                if (includeDate) {
                                    DatePicker(selection: $tempDueDate, in: Date.now..., displayedComponents: .date) {
                                        Text("Select a date")
                                    }
                                }
                                TextField("Rate (optional)", value: $tempRate, format: .number)
                                Picker("Payment Status", selection: $tempPaymentStatus) {
                                    ForEach(Contract.PaymentProgress.allCases, id: \.self) {value in
                                        Text(value.rawValue)
                                    }
                                }
                            }
                        }
                        HStack(spacing: 20) {
                            Spacer()
                            Button {
                                addSheet = false
                                resetValues()
                            } label : {
                                Text("Cancel")
                            }
                            Spacer()
                            Button {
                                formSubmittable = true
                                addSheet = false
                            } label : {
                                Text("Done")
                            } .disabled(submitFormDisabeled)
                            Spacer()
                        }
                    }.interactiveDismissDisabled(true)
                }
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
            agencyViewModel.editContractAsAgency(contract: contract, company: tempCompanyName, influencer: tempName, status: tempStatus, dueDate: useDate, rate: useRate, paymentStatus: tempPaymentStatus, postLink: usePostLink, tasks: tempTasks, isCompleted: tempCompleted, influencerAssignedToContract: tempInfluencerAssigned, miscellaneous: tempMiscellaneous, notes: tempNotes)
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
        tempInfluencerAssigned = ""
        tempInfluencer = User()
        tempTasks = []
        tempMiscellaneous = ""
        tempNotes = ""
        
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
        
        let contractToAdd = Contract(id: UUID().uuidString, company: tempCompanyName, status: tempStatus, influencer: tempName, paymentStatus: tempPaymentStatus, postLink: usePostLink, dueDate: Contract.stringToDateForStorage(stringDate: useDate), rate: useRate, tasks: tempTasks, isCompletedArray: tempCompleted, influencerAssignedToContract : tempInfluencerAssigned, miscellaneous: tempMiscellaneous, notes: tempNotes)
        
        
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
    
}
