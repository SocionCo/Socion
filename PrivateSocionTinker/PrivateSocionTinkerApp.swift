//
//  SocionApp.swift
//  Socion
//
//  Created by Ted Wind on 1/26/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SocionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authentication = Authentication()
    @StateObject var viewmodel = UserViewModel()
    @State var registered : Bool = false
    @State var selected : Bool = false
    @State var agencyRegistration : Bool = false
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if (!selected) {
                    PathSelect(registered: $registered, selected: $selected, agencyRegistration: $agencyRegistration)
                } else {
                    if authentication.isValidated {
                        if (agencyRegistration) {
                            AgencyRegistrationView(selected: $selected)
                        } else {
                            if viewmodel.user.isInfluencer {
                                InfluencerTabSelector()
                            } else if viewmodel.user.isAgencyOwner {
                                ModelView(agencyViewModel: viewmodel.agencyViewModel)
                            } else {
                                ModelView(agencyViewModel: viewmodel.agencyViewModel)
                            }
                        }
                    } else {
                        if (registered) {
                            LogInView(selected : $selected)
                        } else {
                            RegisterView(selected: $selected)
                        }
                    }
                }
            }.environmentObject(authentication).environmentObject(viewmodel)
        }
    }
}
