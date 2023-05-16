import SwiftUI

struct ManageTalentManagers: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var showMenu = false
    @State var darkGreen = Color(red: 19/255, green: 87/255, blue: 65/255)
    @State var green = Color(red: 34/255, green: 139/255, blue: 34/255)
    @ObservedObject var agencyViewModel : AgencyViewModel
    let pasteBoard = UIPasteboard.general
    @State private var inviteSheet : Bool = false
    @State private var linkCopied : Bool = false
    @State private var isShowingPopup = false
    @State private var selectedFriend : User?
    
    
    var body: some View {
        ZStack {
            green.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Talent Managers")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(agencyViewModel.agency.talentManagers) { user in
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
                        
                        HStack(spacing: 15) {
                            Button {
                                inviteSheet = true
                            } label: {
                                VStack(spacing: 5) {
                                    Image(systemName: "plus.circle.fill")
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
                                    Image(systemName: "minus.circle.fill")
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
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
            }
        }.navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $inviteSheet){
            ZStack {
                VStack {
                    Text("Copy Agency Join Code Below")
                        .font(.headline)
                        .padding(.bottom, 20)
                    HStack {
                        TextField("Copy Join Code", text: $userViewModel.agencyViewModel.agency.id)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8.0)
                            .padding(.bottom, 20)
                            .disabled(true)
                        Image(systemName: "doc.on.clipboard.fill").onTapGesture {
                            pasteBoard.string = userViewModel.user.agency
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
        }.sheet(isPresented: $isShowingPopup, content: {
            VStack {
                Text("Select a Talent Manager to Remove")
                    .font(.title)
                    .padding()
                
                List(agencyViewModel.agency.talentManagers, selection: $selectedFriend) { manager in
                    Text("\(manager.firstName) \(manager.lastName)")
                }
                
                Button(action: {
                    if let manager = selectedFriend, let index = agencyViewModel.agency.talentManagers.firstIndex(of: manager) {
                        agencyViewModel.agency.talentManagers.remove(at: index)
                    }
                    isShowingPopup = false
                }) {
                    Text("Remove")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .disabled(selectedFriend == nil)
            }
            .padding()
        })
    }
}
