import SwiftUI

struct AgencySettingsView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                NavigationLink(destination: EditAgencySettingView(settingValue: $userViewModel.agencyViewModel.agency.name)) {
                    HStack {
                        Text("Agency Name")
                        Spacer()
                        Text(userViewModel.agencyViewModel.agency.name)
                            .foregroundColor(.gray)
                    }
                }
            }
        }.navigationTitle("Settings")
    }
}

struct EditAgencySettingView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @Binding var settingValue: String
    @State var confirmValue : String = ""
    @State var showThankYou : Bool = false
    var isButtonDisabled : Bool {
        settingValue != confirmValue
    }
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    TextField("Enter new agency name", text: $settingValue)
                    TextField("Confirm: ", text: $confirmValue)
                    HStack {
                        Spacer()
                        Button {
                            userViewModel.agencyViewModel.changeAgencyName(name: settingValue)
                            withAnimation {
                                showThankYou = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showThankYou = false
                            }
                        } label: {
                            Text("Submit")
                        }.disabled(isButtonDisabled)
                        Spacer()
                    }
                }
            }
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
        }.navigationBarTitle("Edit Setting", displayMode: .inline)
        .background(Color.white)
    }
}
