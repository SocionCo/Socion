import SwiftUI
import _AVKit_SwiftUI

struct AgentDraftDashboard: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @State var contract : Contract
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Array(contract.drafts.enumerated()), id: \.element) { index,element in
                    VideoDraftCardView(draft: contract.drafts[index], userID : userViewModel.agencyViewModel.getOwnerOfContract(contractID: contract.id), contractID: contract.id, draftNumber: index)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(Text("Draft Dashboard"))
    }
}



struct VideoDraftCardView: View {
    let draft: String
    @State var userID : String
    @State var contractID : String
    let draftNumber : Int
    @State var expanded : Bool = false
    @State var showSheet : Bool = false
    @State var notes : String = ""
    @EnvironmentObject var userViewModel : UserViewModel
    @State var refresh : Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var userIndex : Int {
        return userViewModel.agencyViewModel.agency.influencers.firstIndex(where: {$0.id == userID})!
    }
    
    var currentIndex : Int {
        userViewModel.agencyViewModel.agency.influencers[userIndex].contracts.firstIndex(where: {$0.id == contractID}) ?? 0
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                Text("Draft #\(draftNumber + 1)")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            
            HStack {
                switch userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].approvals[draftNumber] {
                    case .unreviewed:
                        Text("unreviewed")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(3)
                            .background(Contract.approvalColor(approval: .unreviewed))
                            .cornerRadius(20)
                    case .approved:
                        Text("approved")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(3)
                            .background(Contract.approvalColor(approval: .approved))
                            .cornerRadius(20)
                    case .rejected:
                        Text("rejected")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(3)
                            .background(Contract.approvalColor(approval: .rejected))
                            .cornerRadius(20)
                    }
                
                Spacer()
                
                switch userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].approvals[draftNumber] {
                    case .unreviewed:
                        HStack {
                            Spacer()
                            Button {
                                userViewModel.agencyViewModel.approveDraft(contractID: contractID, draftName: draft, notes: notes)
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            Button {
                                userViewModel.agencyViewModel.rejectDraft(contractID: contractID, draftName: draft, notes: notes)
                                presentationMode.wrappedValue.dismiss()
                                
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            Button {
                                self.notes = userViewModel.agencyViewModel.agency.influencers[userIndex].contracts[currentIndex].approvalNotes[draftNumber]
                                showSheet = true
                            } label: {
                                Text("Add comments")
                            }
                        }
                        
                        
                    default:
                        Button {
                            userViewModel.agencyViewModel.setDraftToUnreviewed(contractID: contractID, draftName: draft, notes: notes)
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Text("Mark Unreviewed")
                        }
                    }
            }
            .padding(.top, 4)
            
            HStack {
                Spacer()
                    if expanded {
                        VStack {
                            VideoPlayer(player: AVPlayer(url: DocumentServices.getDraftVideoDirectory(contractID: contractID, name: draft)))
                                .scaledToFit()
                            Text("Hide video").onTapGesture {
                                expanded.toggle()
                            }.foregroundColor(.blue)
                        }
                        
                    } else {
                        Text("See video").onTapGesture {
                            expanded.toggle()
                        }.foregroundColor(.blue)
                    }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $showSheet) {
            TextField("Reviewal Comments", text: $notes)
                .lineLimit(7, reservesSpace: true)
                .presentationDetents([.fraction(0.15)])
        }
    }
    
    var menuItems: some View {
        Group {
            Button("Action 1", action: {})
            Button("Action 2", action: {})
            Button("Action 3", action: {})
        }
    }
}

