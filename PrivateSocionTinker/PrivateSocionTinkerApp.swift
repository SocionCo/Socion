//
//  SocionApp.swift
//  Socion
//
//  Created by Ted Wind on 1/26/23.
//

import SwiftUI
import FirebaseCore
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "PrivateSocionTinker")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()

}

@main
struct SocionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authentication = Authentication()
    @StateObject var viewmodel = UserViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            if !authentication.isValidated {
                NavigationView {
                    OpeningPage()
                }
                .environmentObject(authentication)
                .environmentObject(viewmodel)
                .tint(.white)
            } else {
                NavigationView {
                    if viewmodel.user.isInfluencer {
                        //                                ModelView(agencyViewModel: viewmodel.agencyViewModel)
                        InfluencerTabSelector().tint(.blue)
                    } else if viewmodel.user.isAgencyOwner {
                        //                                ModelView(agencyViewModel: viewmodel.agencyViewModel)
                        OwnerTabView().tint(.blue)
                    } else if viewmodel.user.IsTalentManager {
                        //                                ModelView(agencyViewModel: viewmodel.agencyViewModel)
                        TalentManagerTabView().tint(.blue)
                    } else {
                        //                                ModelView(agencyViewModel: viewmodel.agencyViewModel)
                        DefaultTabSelector().tint(.blue)
                    }
                }
                .environmentObject(authentication)
                .environmentObject(viewmodel)
            }
            
        }
        
    }
}
