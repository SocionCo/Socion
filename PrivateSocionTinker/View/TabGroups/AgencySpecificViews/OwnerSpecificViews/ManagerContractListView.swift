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
    @State var tempPaymentStatus : Contract.Progress = .notStarted
    @State var tempInfluencer = User()
    @State var contracts : [Contract] = []
    @EnvironmentObject var authentication : Authentication
    @State var currentlyEditing : Contract?
    @State var formSubmittable : Bool = false
    @State var includeDate : Bool = false
    @State var refresh: Bool = false

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
                    .background(Color(red: 183/255, green: 235/255, blue: 181/255))
                
                SearchBar(searchText: $searchText)
                
                List {
                    Section {
                        ForEach(agencyViewModel.getContracts().sorted(by: sorterForDates), id: \.self) { contract in
                            NavigationLink {
                                ContractDetailView(contract: contract)
                            }
                        label: {
                            VStack (alignment: .leading, spacing: 8) {
                                Text(contract.company)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 183/255, green: 235/255, blue: 181/255))
                                Text(agencyViewModel.getOwnerOfContract(contract: contract)?.getFullName() ?? "")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                HStack {
                                    Text(contract.status.rawValue)
                                        .padding(.all, 7.0)
                                        .font(.title2)
                                        .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(statusColor(contract: contract))
                                        }
                                    if let dueDate = contract.dueDate {
                                        if refresh || !refresh {
                                            let dueString = Contract.timeUntilDate(date: dueDate)
                                            Text("Due in: \(dueString!.trimmingCharacters(in: .whitespaces))")
                                                .font(.title2)
                                                .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                                        }
                                    }
                                }
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
                        authentication.updateValidation(success: false)
                        userViewModel.logOut()
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
                                    tempStatus = contract.status
                                    tempName = contract.name
                                    tempCompanyName = contract.company
                                    currentlyEditing = contract
                                    tempPaymentStatus = contract.paymentStatus
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
                    Section(header: Text("Contract Information")) {
                        TextField("Company Name", text: $tempCompanyName)
                        TextField("Contract Name", text: $tempName)
                        Picker("Status", selection: $tempStatus) {
                            ForEach(Contract.Progress.allCases, id: \.self) {value in
                                Text(value.rawValue)
                            }
                        }
                        TextField("Post Link (optional)", text: $tempPostLink)
                        Toggle(isOn: $includeDate) {
                            Text("Contract has due date")
                        }
                        if (includeDate) {
                            DatePicker(selection: $tempDueDate, in: Date.now..., displayedComponents: .date) {
                                Text("Select a date")
                            }
                        }
                        TextField("Rate (optional)", value: $tempRate, format: .number)
                        Picker("Payment Status", selection: $tempPaymentStatus) {
                            ForEach(Contract.Progress.allCases, id: \.self) {value in
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
            VStack {
            Form {
                Section(header: Text("Contract Information for \(tempInfluencer.getFullName())")) {
                    TextField("Company Name", text: $tempCompanyName)
                    TextField("Contract Name", text: $tempName)
                    Picker("Status", selection: $tempStatus) {
                        ForEach(Contract.Progress.allCases, id: \.self) {value in
                            Text(value.rawValue)
                        }
                    }
                    TextField("Post Link (optional)", text: $tempPostLink)
                    Toggle(isOn: $includeDate) {
                        Text("Contract has due date")
                    }
                    if (includeDate) {
                        DatePicker(selection: $tempDueDate, in: Date.now..., displayedComponents: .date) {
                            Text("Select a date")
                        }
                    }
                    TextField("Rate (optional)", value: $tempRate, format: .number)
                    Picker("Payment Status", selection: $tempPaymentStatus) {
                        ForEach(Contract.Progress.allCases, id: \.self) {value in
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
            agencyViewModel.editContractAsAgency(contract: contract, company: tempCompanyName, influencer: tempName, status: tempStatus, dueDate: useDate, rate: useRate, paymentStatus: tempPaymentStatus, postLink: usePostLink)
            print("Contract status is:: \(contract.status.rawValue)")
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
        tempPaymentStatus = .inProgress
        currentlyEditing = nil
        formSubmittable = false
        tempInfluencer = User()

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
        
        let contractToAdd = Contract(id: UUID().uuidString, company: tempCompanyName, status: tempStatus, influencer: tempName, paymentStatus: tempPaymentStatus, postLink: usePostLink, dueDate: Contract.stringToDateForStorage(stringDate: useDate), rate: useRate)
        
        
        agencyViewModel.addContractToInfluencer(contract: contractToAdd, influencerID: tempInfluencer.id)
        resetValues()
    }
        
    func statusColor(contract: Contract) -> Color {
        switch contract.status {
        case.notStarted:
            return Color(red: 232/255, green: 142/255, blue: 143/255)
        case .inProgress:
            return Color(red: 255/255, green: 255/255, blue: 204/255)
        case .done:
            return Color(red: 183/255, green: 235/255, blue: 181/255)
        }
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
