//
//  UserCredentials.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 3/31/23.
//

import Foundation
import SwiftUI
import CoreData
import Combine

 

struct User : Hashable, Identifiable {
    var id : String = ""
    var firstName: String = ""
    var lastName: String = ""
    var password: String = ""
    var email : String = ""
    var contracts : [Contract] = []
    var isAgencyOwner : Bool = false
    var agency : String?
    var isInfluencer : Bool = false
    var IsTalentManager : Bool = false
    var tikTokUserName : String?
    var instagramUserName : String?
    var youtubeUserName : String?
    var notes : String = ""
    var managedInfluencers : [String]?
    var profilePicture : UIImage = UIImage(systemName: "person.crop.circle.fill") ?? UIImage()
    var profilePictureID : String = ""
    
    func hash (into hasher : inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(password)
        hasher.combine(email)
        hasher.combine(contracts)
        hasher.combine(isAgencyOwner)
        hasher.combine(agency)
        hasher.combine(isInfluencer)
        hasher.combine(IsTalentManager)
        hasher.combine(tikTokUserName)
        hasher.combine(instagramUserName)
        hasher.combine(youtubeUserName)
        hasher.combine(notes)
        hasher.combine(managedInfluencers)
    }
    
    
    init(){}
    
    init(id: String, firstName: String, lastName: String, password: String, email: String, contracts: [Contract], isAgencyOwner: Bool, agency: String? = nil, isInfluencer: Bool, IsTalentManager: Bool, tikTokUserName : String, youtubeUserName : String, instagramUserName : String, notes : String, managedInfluencers : [String]?, profilePic: UIImage?) {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.email = email
        self.contracts = contracts
        self.isAgencyOwner = isAgencyOwner
        self.agency = agency
        self.isInfluencer = isInfluencer
        self.IsTalentManager = IsTalentManager
        self.tikTokUserName = tikTokUserName
        self.instagramUserName = instagramUserName
        self.notes = notes
        self.youtubeUserName = youtubeUserName
        self.managedInfluencers = managedInfluencers
        if profilePic == nil {
            self.profilePicture = UIImage(systemName: "person.crop.circle.fill") ?? UIImage()
        } else {
            self.profilePicture = profilePic!
        }
        self.profilePictureID = DataManager.getLocalProfilePicID(userID: id, context: delegate.persistentContainer.viewContext) ?? "default"
        
    }
    
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
    
    
    
    
}
