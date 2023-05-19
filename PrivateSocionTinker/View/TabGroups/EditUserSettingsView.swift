import SwiftUI

struct EditUserSettingsView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                NavigationLink(destination: EditFirstNameSettingView(settingValue: $userViewModel.user.firstName)) {
                    HStack {
                        Text("First Name")
                        Spacer()
                        Text(userViewModel.user.firstName)
                            .foregroundColor(.gray)
                    }
                }
                NavigationLink(destination: EditLastNameSettingView(settingValue: $userViewModel.user.lastName)) {
                    HStack {
                        Text("Last Name")
                        Spacer()
                        Text(userViewModel.user.lastName)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section(header: Text("Account")) {
                NavigationLink(destination: EditEmailSettingView(settingValue: $userViewModel.user.email)) {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(userViewModel.user.email)
                            .foregroundColor(.gray)
                    }
                }
                NavigationLink(destination: EditTikTokUserNameSettingsView(settingValue: $userViewModel.user.password)) {
                    HStack {
                        Text("TikTok Username")
                        Spacer()
                        Text(userViewModel.user.tikTokUserName ?? " ")
                            .foregroundColor(.gray)
                    }
                }
                NavigationLink(destination: EditInstagramUserNameSettingsView(settingValue: $userViewModel.user.password)) {
                    HStack {
                        Text("Instagram Username")
                        Spacer()
                        Text(userViewModel.user.instagramUserName ?? " ")
                            .foregroundColor(.gray)
                    }
                }
                NavigationLink(destination: EditYoutubeUserNameSettingsView(settingValue: $userViewModel.user.password)) {
                    HStack {
                        Text("Youtube Username")
                        Spacer()
                        Text(userViewModel.user.youtubeUserName ?? " ")
                            .foregroundColor(.gray)
                    }
                }
            }
                
            Section(header: Text("Profile Picture")) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
                    .foregroundColor(.systemGray2)
                
                NavigationLink {
                    ChangePFPView()
                } label: {
                    Text("Change Profile Picture")
                        .foregroundColor(.blue)
                }
            }
                
                
                
            
        }.navigationTitle("Settings")
    }
}

struct EditFirstNameSettingView: View {
    @Binding var settingValue: String
    @State var confirmValue: String = ""
    @State var showThankYou : Bool = false
    @EnvironmentObject var userViewModel : UserViewModel
    var isButtonDisabled : Bool {
        settingValue != confirmValue
    }
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    TextField("Enter first name", text: $settingValue)
                    TextField("Confirm first name: ", text: $confirmValue)
                    HStack {
                        Spacer()
                        Button {
                            userViewModel.setFirstName(name: settingValue)
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


struct EditLastNameSettingView: View {
    @Binding var settingValue: String
    @State var confirmValue: String = ""
    @State var showThankYou : Bool = false
    @EnvironmentObject var userViewModel : UserViewModel
    var isButtonDisabled : Bool {
        settingValue != confirmValue
    }
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    TextField("Enter last name:", text: $settingValue)
                    TextField("Confirm last name: ", text: $confirmValue)
                    HStack {
                        Spacer()
                        Button {
                            userViewModel.setLastName(name: settingValue)
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

struct EditEmailSettingView: View {
    @Binding var settingValue: String
    @State var confirmValue: String = ""
    @State var showThankYou : Bool = false
    @EnvironmentObject var userViewModel : UserViewModel
    var isButtonDisabled : Bool {
        settingValue != confirmValue
    }
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    TextField("Enter new value", text: $settingValue)
                    TextField("Confirm: ", text: $confirmValue)
                    HStack {
                        Spacer()
                        Button {
                            userViewModel.setEmail(email: settingValue)
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

struct EditTikTokUserNameSettingsView: View {
    @Binding var settingValue: String
    @State var confirmValue: String = ""
    @State var showThankYou : Bool = false
    @EnvironmentObject var userViewModel : UserViewModel
    var isButtonDisabled : Bool {
        settingValue != confirmValue
    }
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    TextField("Enter new value", text: $settingValue)
                    TextField("Confirm: ", text: $confirmValue)
                    HStack {
                        Spacer()
                        Button {
                            userViewModel.setTikTokUsername(username: settingValue)
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

struct EditYoutubeUserNameSettingsView: View {
    @Binding var settingValue: String
    @State var confirmValue: String = ""
    @State var showThankYou : Bool = false
    @EnvironmentObject var userViewModel : UserViewModel
    var isButtonDisabled : Bool {
        settingValue != confirmValue
    }
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    TextField("Enter new value", text: $settingValue)
                    TextField("Confirm: ", text: $confirmValue)
                    HStack {
                        Spacer()
                        Button {
                            userViewModel.setYoutubeUserName(username: settingValue)
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

struct EditInstagramUserNameSettingsView: View {
    @Binding var settingValue: String
    @State var confirmValue: String = ""
    @State var showThankYou : Bool = false
    @EnvironmentObject var userViewModel : UserViewModel
    var isButtonDisabled : Bool {
        settingValue != confirmValue
    }
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    TextField("Enter new value", text: $settingValue)
                    TextField("Confirm: ", text: $confirmValue)
                    HStack {
                        Spacer()
                        Button {
                            userViewModel.setInstagramUserName(username: settingValue)
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
