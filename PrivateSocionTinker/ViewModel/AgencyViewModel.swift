//
//  AgencyViewModel.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/7/23.
//

import Foundation
import SwiftUI

class AgencyViewModel : ObservableObject {
    @Published var agency = Agency()
    var initialPop : Bool = true
    
    func getListOfAllAgencyContracts() -> [Contract] {
        print("Retrieving all contracts")
        print("Agency has \(agency.influencers.count) influencers")
        print("Influencer has \(agency.influencers[0].contracts.count) contracts")
        var returnArray : [Contract] = []
        for influencer in agency.influencers {
            print("Appending to returnArray an array \(influencer.contracts.count) contracts")
            returnArray.append(contentsOf: influencer.contracts)
        }
        return returnArray
    }
    
    
    func createAgencyForUser(userID : String, agencyName : String) -> String {
        return FireBaseDataServices.shared.startAgency(ownerId: userID, agencyName: agencyName)
    }
    
    
    //MARK: Agency Log-In Sequence
    
    func initiateAgencyListeners(userViewModel : UserViewModel) {
        self.attachAgencyInfoListeners(agencyID: userViewModel.user.agency!)
        self.attachInfluencerInfoListenersToAgency(agencyID: userViewModel.user.agency!)
        
    }
    
    private func attachAgencyInfoListeners (agencyID : String) {
        FireBaseDataServices.shared.db.collection("agencies").document(agencyID).addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("Guard failed line 42 AgencyViewModel")
                return
            }
            
            guard let data = documentSnapshot.data() else {
                print("Document data empty")
                return
            }
            
            self.updateOnlyAgencyInfo(data: data)
        }
        
    }
    
    private func attachInfluencerInfoListenersToAgency(agencyID : String) {
        FireBaseDataServices.shared.db.collection("agencies").document(agencyID).getDocument { document, error in
            
            guard let document = document else {
                print("Error line 59 AgencyViewModel")
                return
            }
            
            guard let data = document.data() else {
                print("Error line 64 AgencyViewModel")
                return
            }
            
            guard let influencers = data["influencers"] as? [String] else {
                print("Error line 69 AgencyViewModel")
                return
            }
            self.attachContractListeners(influencers: influencers)
            for influencerID in influencers {
                print("Adding listener to influencer")
                self.attachSnapshotListenerToInvdividual(userID: influencerID)
            }
            
        }
    
    }
    
    private func attachSnapshotListenerToInvdividual (userID: String) {
        FireBaseDataServices.shared.db.collection("users").document(userID).addSnapshotListener { snapshot, error in
            var userToRemove : User
            var indexToRemove : Int?
            var userExistsLocally : Bool = false
            
            for currentInfluencer in self.agency.influencers {
                if currentInfluencer.id == userID {
                    userExistsLocally = true
                    userToRemove = currentInfluencer
                    indexToRemove = self.agency.influencers.firstIndex(of: userToRemove)
                }
            }
            if userExistsLocally {
                if let indexToRemove = indexToRemove {
                    self.agency.influencers.remove(at:indexToRemove)
                }
            }
            FireBaseDataServices.shared.getUserFromID(userID: userID ) {newUser in
                print("Appending New User")
                self.agency.influencers.append(newUser)
            }
        }
    }
    
    private func attachContractListeners (influencers : [String]) {
        for influencer in influencers {
            FireBaseDataServices.shared.db.collection("users").document(influencer).collection("contracts").addSnapshotListener { snapshot, error in
                if self.initialPop {
                    self.initialPop = false
                    return
                }
                print("Contract listener popped")
                var userToRemove : User
                var indexToRemove : Int?
                var userExistsLocally : Bool = false
                
                for currentInfluencer in self.agency.influencers {
                    print("Checking \(currentInfluencer.id) against \(influencer)")
                    if currentInfluencer.id == influencer {
                        print("They are the same")
                        userExistsLocally = true
                        userToRemove = currentInfluencer
                        indexToRemove = self.agency.influencers.firstIndex(of: userToRemove)
                    }
                }
                if userExistsLocally {
                    if let indexToRemove = indexToRemove {
                        print("Removing user")
                        self.agency.influencers.remove(at:indexToRemove)
                    }
                }
                FireBaseDataServices.shared.getUserFromID(userID: influencer ) {newUser in
                    print("Appending New User")
                    self.agency.influencers.append(newUser)
                }
            }
        }
        
    }
    
    
    
    private func updateOnlyAgencyInfo (data : [String : Any]) {
        
        if let name : String = data["name"] as? String {
            agency.name = name
        }
        
        if let owner : String = data["owner"] as? String {
            FireBaseDataServices.shared.getUserFromID(userID: owner) {newUser in
                self.agency.owner = newUser
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Getters and Setters (Changers) for Agency
    
    func changeAgencyName (name : String) {
        
        print("Using ID: \(agency.id)")
        FireBaseDataServices.shared.changeAgencyName(id: agency.id, name: name)
    }
    
    func getAgencyID () -> String {
        return self.agency.id
    }
    
    func getAgencyName() -> String {
        return self.agency.name
    }
}
