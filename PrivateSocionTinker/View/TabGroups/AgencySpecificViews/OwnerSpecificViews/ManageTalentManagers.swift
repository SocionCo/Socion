import SwiftUI

struct ManageTalentManagers: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var showMenu = false
    @State var darkGreen = Color(red: 19/255, green: 87/255, blue: 65/255)
    @State var green = Color(red: 34/255, green: 139/255, blue: 34/255)
    let backgroundColor = Color(.sRGB, red: 0.93, green: 0.96, blue: 0.93, opacity: 1.0)
    let primaryColor = Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0)
    let secondaryColor = Color(.white)
    @ObservedObject var agencyViewModel : AgencyViewModel
    let pasteBoard = UIPasteboard.general
    @State private var inviteSheet : Bool = false
    @State private var linkCopied : Bool = false
    @State private var isShowingPopup = false
    @State private var selectedFriend : User?
    @State private var manageManagers : Bool = false
    @State private var refresh : Bool = false
    @State var inviteText : String = ""
    
    
    var body: some View {
        ZStack {
            green.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Button {
                            manageManagers = true
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName: "person.2")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("Manage Talent Managers")
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(darkGreen)
                            .cornerRadius(10)
                        }
                        
                        HStack(spacing: 15) {
                            Button {
                                inviteSheet = true
                            } label: {
                                VStack(spacing: 5) {
                                    Image(systemName: "plus.circle")
                                        .font(.title)
                                        .foregroundColor(.white)
                                    Text("Add Talent Manager")
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(darkGreen)
                                .cornerRadius(10)
                            }
                            
                            Button {
                                isShowingPopup = true
                            } label: {
                                VStack(spacing: 5) {
                                    Image(systemName: "minus.circle")
                                        .font(.title)
                                        .foregroundColor(.white)
                                    Text("Remove Talent Manager")
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(darkGreen)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        
                        Text("Join Requests")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        
                        if agencyViewModel.getAllRequests().count > 0 {
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(agencyViewModel.getAllRequests()) { user in
                                        VStack(alignment: .leading, spacing: 10) {
                                            Image(systemName: "person.crop.circle.fill")
                                                .font(.system(size: 44))
                                                .foregroundColor(.white)
                                                .padding(.bottom, 10)
                                            
                                            
                                            Text("\(user.firstName) \(user.lastName) ")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            
                                            HStack(spacing: 15) {
                                                Button(action: {
                                                    withAnimation {
                                                        agencyViewModel.approveTalentManager(userID: user.id)
                                                        refresh.toggle()
                                                    }
                                                }) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.white)
                                                        .padding(10)
                                                        .background(Color.green)
                                                        .clipShape(Circle())
                                                }
                                                
                                                Button(action: {
                                                    withAnimation {
                                                        agencyViewModel.declineTalentManager(userID: user.id)
                                                    }
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.white)
                                                        .padding(10)
                                                        .background(Color.red)
                                                        .clipShape(Circle())
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: 200, height: 250)
                                    .background(darkGreen)
                                    .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        } else {
                            Text("No New Talent Manager Requests!").foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .onAppear {
            inviteText = "0T-\(agencyViewModel.agency.id)"
        }
        .onTapGesture {
            print("Requests:")
            print(agencyViewModel.getAllRequests())
            print("Talent Managers:")
            print(agencyViewModel.agency.talentManagers)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $inviteSheet){
            ZStack {
                VStack {
                    Text("Copy Agency Join Code Below")
                        .font(.headline)
                        .padding(.bottom, 20)
                    HStack {
                        TextField("Copy Join Code", text: $inviteText)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8.0)
                            .padding(.bottom, 20)
                            .disabled(true)
                        Image(systemName: "doc.on.clipboard.fill").onTapGesture {
                            pasteBoard.string = inviteText
                            print(userViewModel.agencyViewModel.agency.id)
                            withAnimation {
                                linkCopied = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    linkCopied = false
                                }
                            }
                            
                        }
                    }
                }
                
                .padding()
                .background(Color.white)
                .cornerRadius(16.0)
                .padding(.horizontal, 20)
                .presentationDetents([.fraction(0.4)])
                if linkCopied {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                        .opacity(0.5)
                        .frame(width: 125, height: 100)
                        .overlay(
                            VStack {
                                Text("Link Copied")
                            }
                        )
                }
            }
        }
        .sheet(isPresented: $isShowingPopup, content: {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Talent Managers")
                        .font(.largeTitle)
                        .foregroundColor(primaryColor)
                        .padding(.top, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(agencyViewModel.getAllTalentManagers()) { talentManager in
                                TalentManagerRow(agencyViewModel: agencyViewModel, talentManager: talentManager)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .edgesIgnoringSafeArea(.all)
        })
        .sheet(isPresented: $manageManagers) {
            PersonListView(agencyViewModel: agencyViewModel)
        }
    }
}

struct TalentManagerRow: View {
    let agencyViewModel : AgencyViewModel
    let talentManager : User
    let backgroundColor = Color(.sRGB, red: 0.93, green: 0.96, blue: 0.93, opacity: 1.0)
    let primaryColor = Color(.sRGB, red: 0.08, green: 0.39, blue: 0.22, opacity: 1.0)
    let secondaryColor = Color(.white)
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
            
            Text("\(talentManager.firstName) \(talentManager.lastName)")
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                agencyViewModel.removeTalentManagerFromAgency(talentManagerID: talentManager.id)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(primaryColor)
        .cornerRadius(10)
    }
}

struct PersonListView: View {
    @State private var selectedTalentManager: User?
    @State private var selectedInfluencers : [String]?
    @ObservedObject var agencyViewModel : AgencyViewModel
    
    var body: some View {
            
        NavigationView {
            List(agencyViewModel.getAllTalentManagers()) { talentManager in
                Text(talentManager.getFullName())
                    .font(.headline)
                    .onTapGesture {
                        selectedTalentManager = talentManager
                        selectedInfluencers = selectedTalentManager?.managedInfluencers
                    }
            }
            .navigationTitle("Talent Managers")
            .sheet(item: $selectedTalentManager) { talentManager in
                AttributeListView(talentManager: talentManager, selectedInfluencers: $selectedInfluencers, agencyViewModel: agencyViewModel)
            }
        }
    }
}

struct AttributeListView: View {
    let talentManager: User
    @Binding var selectedInfluencers : [String]?
    @ObservedObject var agencyViewModel : AgencyViewModel
    
    var body: some View {
        List(agencyViewModel.getInfluencers()) { influencer in
            
            Text(influencer.getFullName())
                .font(.subheadline)
                .foregroundColor(selectedInfluencers!.contains(influencer.id) ? .blue : .primary)
                .onTapGesture {
                    if (selectedInfluencers!.contains(influencer.id)) {
                        agencyViewModel.removeInfluencerFromTalentManager(talentManagerID: talentManager.id, influencerID: influencer.id)
                        selectedInfluencers?.remove(at: (selectedInfluencers?.firstIndex(of: influencer.id)!)!)
                    } else {
                        agencyViewModel.assignInfluencerToTalentManager(talentManagerID: talentManager.id, influencerID: influencer.id)
                        selectedInfluencers!.append(influencer.id)
                    }
                }
        }
        .navigationTitle("Influencers Assigned to \(talentManager.getFullName())")
        .navigationBarItems(trailing: Button("Done") {
            selectedInfluencers = nil
        })
    }
}



