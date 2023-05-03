import SwiftUI

struct NoAgencyView: View {
    @State var codeSheet = false
    @State var joinCode = ""
    @EnvironmentObject var userViewModel : UserViewModel
    @State var showThankYou = false
    @State var showFailure = false
    @State var wasSuccessful = false
    @State var textFieldDisabled = false
    @State var joiningAsTalentManager = false
    let pasteBoard = UIPasteboard.general
    var body: some View {
        
        ZStack {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.white, Color.green.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                        
                        NavigationLink(destination: (AgencySettingsView())) {
                            navigationLinkView(destination: "Edit Agency Settings")
                        }
                        NavigationLink(destination: EditUserSettingsView()) {
                            navigationLinkView(destination: "Edit User Settings")
                        }
                        NavigationLink(destination: ManageInfluencersView()) {
                            navigationLinkView(destination: "Manage Influencers")
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 80)
                    .padding(.horizontal)
                }.blur(radius: 20).disabled(true)
                
            }
            .navigationTitle("Dashboard")
            .foregroundColor(.white)
            .toolbarColorScheme(.dark, for: .navigationBar).blur(radius: 20)
            
            HStack {
                Spacer()
                VStack {
                    Text("Not Unlocked")
                    Text("Tap to Enter Agency Code").fontWeight(.bold).onTapGesture {
                        codeSheet = true
                    }
                }.foregroundColor(.white)
                Spacer()
            }.sheet(isPresented: $codeSheet) {
                ZStack {
                    VStack {
                        Text("Enter Agency Join Code Below")
                            .font(.headline)
                            .padding(.bottom, 20)
                        HStack {
                            TextField("Enter Join Code", text: $joinCode)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8.0)
                                .padding(.bottom, 20)
                                .disabled(textFieldDisabled)
                            Image(systemName: "doc.on.clipboard.fill").onTapGesture {
                                if(pasteBoard.string != nil) {
                                    joinCode = pasteBoard.string!
                                }
                            }
                        }
                        Toggle(isOn: $joiningAsTalentManager) {
                            Text("Join as Talent Manager?")
                                .font(.subheadline)
                        }
                        Spacer()
                        
                        Button(action: {
                            textFieldDisabled = true
                            if !joiningAsTalentManager {
                                userViewModel.attachInfluencerToAgency(agencyID: joinCode)
                                FireBaseDataServices.shared.documentExists(agencyID: joinCode) { completion in
                                    print("Printing completion: \(completion)")
                                    if completion {
                                        userViewModel.addInfluencerToAgency(agencyID: joinCode)
                                        withAnimation {
                                            showThankYou = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            codeSheet = false
                                            showThankYou = false
                                        }
                                    } else {
                                        withAnimation {
                                            showFailure = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            codeSheet = false
                                            showFailure = false
                                            
                                        }
                                    }
                                }
                            } else {
                                userViewModel.attachTalentManagerToAgency(agencyID: joinCode)
                                FireBaseDataServices.shared.documentExists(agencyID: joinCode) {
                                    completion in
                                    if completion {
                                        userViewModel.addTalentManagerToAgency(agencyID: joinCode)
                                        withAnimation {
                                            showThankYou = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            codeSheet = false
                                            showThankYou = false
                                        }
                                    } else {
                                        withAnimation {
                                            showFailure = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            codeSheet = false
                                            showFailure = false
                                        }
                                    }
                                }
                            }
                            textFieldDisabled = false
                        }) {
                            Text("Submit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(8.0)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16.0)
                    .padding(.horizontal, 20)
                    .presentationDetents([.fraction(0.4)])
                    Spacer()
                    if showThankYou {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                            .opacity(0.5)
                            .frame(width: 125, height: 100)
                            .overlay(
                                VStack {
                                    Text("Successful")
                                }
                            )
                    }
                    
                    if showFailure {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                            .opacity(0.5)
                            .frame(width: 125, height: 100)
                            .overlay(
                                VStack {
                                    Text("Unsuccessful")
                                }
                            )
                    }
                }
            }
        }
    }
}

    
