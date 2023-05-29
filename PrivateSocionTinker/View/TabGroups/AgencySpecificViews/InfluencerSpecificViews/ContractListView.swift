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
    @EnvironmentObject var authentication : Authentication
    @State var currentlyEditing : Contract?
    @State var formSubmittable : Bool = false
    @State var includeDate : Bool = false
    @State var tempTasks : [String] = []
    @State var tempCompleted : [Bool] = []
    @State var greenColor = Color(red: 183/255, green: 215/255, blue: 181/255)
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
                    
                    SearchBar(searchText: $searchText)
                }
                .background(.green)
                
                
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
                        Button("New Contract") {
                            addSheet = true
                            formSubmittable = true
                        }
                        Menu("Delete Contract") {
                            ForEach(userViewModel.user.contracts, id: \.self) { contract in
                                Button(contract.company) {
                                    userViewModel.deleteContract(contract: contract)
                                }
                            }
                        }
                        Menu("Edit") {
                            ForEach(userViewModel.user.contracts, id: \.self) { contract in
                                Button(contract.company) {
                                    tempStatus = contract.getStatus()
                                    tempName = contract.name
                                    tempCompanyName = contract.company
                                    currentlyEditing = contract
                                    tempPaymentStatus = contract.paymentStatus
                                    tempTasks = contract.tasks
                                    tempCompleted = contract.isCompletedArray
                                    if contract.rate != nil {
                                        tempRate = contract.rate!
                                    }
                                    if contract.dueDate != nil {
                                        tempDueDate = contract.dueDate!
                                    }
                                    editSheet.toggle()
                                    if contract.postLink != nil {
                                        tempPostLink = contract.postLink!
                                    }
                                    if contract.influencerAssignedToContract != nil {
                                        tempInfluencerAssigned = contract.influencerAssignedToContract!
                                    }
                                    tempAttachments = contract.attachments
                                    tempNotes = contract.notes
                                }
                            }
                        }
                    }
                }
            }.foregroundColor(.white)
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
            userViewModel.editContract(contract: contract, company: tempCompanyName, influencer: tempName, status: tempStatus, dueDate: useDate, rate: useRate, paymentStatus: tempPaymentStatus, postLink: usePostLink, tasks: tempTasks, isCompleted: tempCompleted, influencerAssignedToContract: tempInfluencerAssigned, attachments: tempAttachments, notes: tempNotes)
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
        
        let contractToAdd = Contract(id: UUID().uuidString, company: tempCompanyName, status: tempStatus, influencer: tempName, paymentStatus: tempPaymentStatus, postLink: usePostLink, dueDate: Contract.stringToDateForStorage(stringDate: useDate), rate: useRate, tasks: tempTasks, isCompletedArray: tempCompleted, influencerAssignedToContract: tempInfluencerAssigned, attachments: tempAttachments, notes: tempNotes)
        
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
    
}
