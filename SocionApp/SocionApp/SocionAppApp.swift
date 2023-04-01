//
//  SocionApp.swift
//  Socion
//
//  Created by Daniel Biundo on 4/1/23.
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
    @State var registered : Bool = false
    @State var selected : Bool = false
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if (!selected) {
                    PathSelect(registered: $registered, selected: $selected)
                } else {
                    if authentication.isValidated {
                        ExampleContent().environmentObject(authentication)
                    } else {
                        if (registered) {
                            LogInView().environmentObject(authentication)
                        } else {
                            RegisterView().environmentObject(authentication)
                        }
                    }
                }
            }
        }
    }
}
