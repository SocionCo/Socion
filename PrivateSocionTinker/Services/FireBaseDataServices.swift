//
//  FireBaseDataServices.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/1/23.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftUI

/// Class with a singleton (shared) that should be the access point for all interactions with the FireStore database.
class FireBaseDataServices {
    static let shared = FireBaseDataServices()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let db = Firestore.firestore()
    
    
    /// Initializes an instance of a user in the database. This will only be called when a User has first register, and populates only the required information. The Contracts collection isn't initialized until one is added for the first time.
    /// - Parameters:
    ///   - id: User ID, the one provided by FireBase and returned from the Authentication.authentication.getUserID() command
    ///   - firstName: First Name
    ///   - lastName: Last Name
    ///   - email: Email
    func startUser (id: String, firstName : String, lastName : String, email : String, isAgencyOwner : Bool, agency : String?, isTalentManager : Bool, isInfluencer : Bool, tikTokUserName : String?, instagramUserName : String?, youtubeUserName : String?, notes : String, managedInfluencers : [String]?, profilePictureID : String) {
        let userAgencyID : String = agency == nil ? String() : agency!
        let unwrappedTikTok : String = tikTokUserName == nil ? "" : tikTokUserName!
        let unwrappedYoutube : String = youtubeUserName == nil ? "" : youtubeUserName!
        let unwrappedInstagram : String = instagramUserName == nil ? "" : instagramUserName!
        let unwrappedInfluencers : [String] = managedInfluencers == nil ? [] : managedInfluencers!
        print("1Calling document: \(id)")
        db.collection("users").document(id).setData([
            "email" : email,
            "firstName" : firstName,
            "lastName" : lastName,
            "isAgencyOwner" : isAgencyOwner,
            "agency" : userAgencyID,
            "isTalentManager" : isTalentManager,
            "isInfluencer" : isInfluencer,
            "tikTokUserName" : unwrappedTikTok,
            "instagramUserName" : unwrappedInstagram,
            "youtubeUserName" : unwrappedYoutube,
            "notes" : notes,
            "managedInfluencers" : unwrappedInfluencers,
            "profilePictureID" : profilePictureID
        ])
        
    }
    

    /// Marks a user as an influencer, and assigns them to a provided agency
    /// - Parameters:
    ///   - userID: userID String
    ///   - agencyID: agencyID String
    func assignInfluencerToAgency (userID : String, agencyID : String) {
        self.documentExists(agencyID: agencyID) { completion in
            if completion {
                print("3Calling document: \(userID)")
                self.db.collection("users").document(userID).updateData([
                    "isInfluencer" : true,
                    "agency" : agencyID
                ])
                print("Completion successful")
            }
            else {
                print("Agency not found")
            }
        }
    }
    
    func assignTalentManagerToAgency (userID : String, agencyID : String) {
        self.documentExists(agencyID: agencyID) { completion in
            if completion {
                print("3Calling document: \(userID)")
                self.db.collection("users").document(userID).updateData([
                    "agency" : agencyID
                ])
                print("Completion successful")
            }
            else {
                print("Agency not found")
            }
        }
    }

    
    /// Initializes a new agency in FireStore. Initializes and fills in values for ownerID, agencyName, and puts it under a document with the name agencyID in the agencies collection. Intiailizes but does not store values in influencers and talent managers section.
    /// - Parameters:
    ///   - ownerId: UUID of the user that is the "Creator" of the Agency
    ///   - agencyName: String name of Agency (i.e. Viralist)
    ///   - return: returns a UUID string which serves as the UUID for the agency
    func startAgency (ownerId : String, agencyName : String) -> String {
        let agencyID : String = UUID().uuidString
        db.collection("agencies").document(agencyID).setData([
            "influencers" : [],
            "name" : agencyName,
            "owner" : ownerId,
            "talentManagers" : []
            ])
        return agencyID
    }
    
    /// Checks to see if a an agency exists with a given name, with a completion callback
    /// - Parameters:
    ///   - agencyID: string of agency ID
    ///   - completion: completion callback, true or false, true meaning agency exists
    func documentExists(agencyID: String, completion: @escaping (Bool) -> Void) {
        print("Entered Document Exists")
        print("4Calling document: \(agencyID)")
        let agenciesCollection = FireBaseDataServices.shared.db.collection("agencies").document(agencyID)

        agenciesCollection.getDocument { document, error in
            guard let document = document else  {
                print("Returning false unexpectedly")
                completion(false)
                return
            }
            if document.exists {
                    completion(true)
                    print("Returning true from closure")
                  } else {
                      completion(false)
                     print("Returning false from closure")
                  }
        }
        
    }
  

    
    /// This adds a new contract under the current user, creating a contract collections if it hasn't yet been initialized.
    /// - Parameters:
    ///   - id: UUID provided by the ViewModel
    ///   - contract: the contract to be added
    func addContract (id: String, contract : Contract) {
        var unwrappedRate : Double = 0
        if contract.rate != nil {
            unwrappedRate = contract.rate!
        }
        let unwrappedDate = returnUnwrappedOrEmptyString(optional: Contract.dateToStringForStorage(date: contract.dueDate))
        let unwrappedPostLink = returnUnwrappedOrEmptyString(optional: contract.postLink)
        let unwrappedInfluencerAssigned = returnUnwrappedOrEmptyString(optional: contract.influencerAssignedToContract)
        print("5Calling document: \(contract.id)")
        print("6Calling document: \(id)")
        db.collection("users").document(id).collection("contracts").document(contract.id).setData([
            "company" : contract.company,
            "status" : AgencyViewModel.getStatus(contract: contract),
            "name" : contract.name,
            "rate" : unwrappedRate,
            "paymentStatus" : contract.paymentStatus.rawValue,
            "postLink" : unwrappedPostLink,
            "dueDate" : unwrappedDate,
            "tasks" : contract.tasks,
            "completedTasks" : contract.isCompletedArray,
            "influencerAssignedToContract" : unwrappedInfluencerAssigned,
            "attachments" : contract.attachments,
            "notes" : contract.notes
        ])
    }
    
    func updateContractPaymentStatus (userID : String, contract : Contract, newPaymentStatus : Contract.PaymentProgress) {
        db.collection("users").document(userID).collection("contracts").document(contract.id).updateData([
            "paymentStatus" : newPaymentStatus.rawValue
        ])
    }
    
    func updateContractStatus (userID : String, contract : Contract, newStatus : Contract.Progress) {
        db.collection("users").document(userID).collection("contracts").document(contract.id).updateData([
            "status" : newStatus.rawValue
        ])
    }
    
    
    func restoreContract (userID : String, contract : Contract) {
        db.collection("users").document(userID).collection("contracts").document(contract.id).updateData([
            "paymentStatus" : Contract.PaymentProgress.notPaid.rawValue
        ])
    }
    
    
    func removeInfluencerFromAgency (agencyID : String, influencerID : String) {
        db.collection("agencies").document(agencyID).updateData([
            "influencers" : FieldValue.arrayRemove([influencerID])
        ])
        db.collection("users").document(influencerID).updateData([
            "isInfluencer" : false,
            "agency" : ""
        ])
    }
    
    /// Adds influencerID to the influencer Array of a particular AgencyID
    /// - Parameters:
    ///   - agencyID: agencyID String
    ///   - influencerID: influencerID Strng
    func addInfluencerToAgency (agencyID : String, influencerID : String) {
        print("7Calling document: \(agencyID)")
        db.collection("agencies").document(agencyID).updateData([
            "influencers": FieldValue.arrayUnion([influencerID])
            ])
    }
    
    func addTalentManagerToAgency (agencyID : String, talentManagerID: String) {
        db.collection("agencies").document(agencyID).updateData([
            "talentManagers": FieldValue.arrayUnion([talentManagerID])
            ])
    }
    
    func removeTalentManagerFromAgency (agencyID : String, talentManagerID : String) {
        db.collection("agencies").document(agencyID).updateData([
            "talentManagers" : FieldValue.arrayRemove([talentManagerID])
        ])
        db.collection("users").document(talentManagerID).updateData([
            "isTalentManager" : false,
            "managedInfluencers" : []
        ])
    }
    
    func addInfluencerToTalentManager (talentManagerID : String, influencerID : String) {
        let userRef = db.collection("users")
        userRef.document(talentManagerID).updateData([
            "managedInfluencers" : FieldValue.arrayUnion([influencerID])
        ])
    }
    
    func removeInfluencerFromTalentManager (talentManagerID : String, influencerID : String) {
        let userRef = db.collection("users")
        userRef.document(talentManagerID).updateData([
            "managedInfluencers" : FieldValue.arrayRemove([influencerID])
        ])
    }
    
    
    
    
    
    func getContracts(userID : String)  -> [Contract] {
        var returnArray : [Contract] = []
        print("1Calling document: \(userID)")
         db.collection("users").document(userID).collection("contracts").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error unpacking contracts")
                return
            }
            print("Document count \(documents.count)")
            for queryDocumentSnapshot in documents {
                print("Entered for loop")
                returnArray.append(Contract.toContractFromStringMap(id: queryDocumentSnapshot.documentID, stringMap: queryDocumentSnapshot.data()))
                print("Inside closure count \(returnArray.count)")
            }
        }
        print("Now returning array of length \(returnArray.count)")
        return returnArray
    }
    
    /// Deletes contract document of the provided ID
    /// - Parameters:
    ///   - id: FireStore id of deleted contract
    ///   - contract: Contract contents to be deleted
    func deleteContract (userID : String, contract : Contract) {
        db.collection("users").document(userID).collection("contracts").document(contract.id).delete()
    }
    
    /// Assigns user as an owner of the provided Agency
    /// - Parameters:
    ///   - userID: userID string
    ///   - agencyID: agencyID String
    func assignUserAsOwner (userID : String, agencyID : String) {
        print("10Calling document: \(userID)")
        db.collection("users").document(userID).updateData([
            "isAgencyOwner" : true,
            "agency" : agencyID
        ])
    }
    
    func setEmail (userID: String, email : String) {
        db.collection("users").document(userID).updateData([
            "email" : email
        ])
    }
    
    func changeAgencyName(id : String, name : String) {
        print("11Calling document: \(id)")
        db.collection("agencies").document(id).updateData([
            "name" : name
        ])
    }
    
    func addTasktoContract(userID : String, contract : Contract, task : String) {
        print("Adding task to \(userID)")
        var editedContract : [Bool] = contract.isCompletedArray
        print("Original: \(editedContract)")
        print("Original: \(contract.tasks)")
        editedContract.append(false)
        print(editedContract)
        db.collection("users").document(userID).collection("contracts").document(contract.id).updateData([
            "tasks" : FieldValue.arrayUnion([task]),
            "completedTasks" : editedContract
        ])
    }
    
    func removeTaskFromContract(userID: String, contract : Contract, task : String) {
        var editedContract = contract.tasks
        var editedCompletionArray = contract.isCompletedArray
        print("EditedContractLength: \(editedContract.count)")
        print("EditedCompletionLength: \(editedCompletionArray.count)")
        if let indexOfRemovedTask = editedContract.firstIndex(where: {$0 == task}) {
            editedContract.remove(at: indexOfRemovedTask)
            editedCompletionArray.remove(at: indexOfRemovedTask)
            db.collection("users").document(userID).collection("contracts").document(contract.id).updateData([
                "tasks" : editedContract,
                "completedTasks" : editedCompletionArray
                
            ])
        }
    }
    
    func toggleTask (userID: String, contract: Contract, task : String) {
        var editedCompletionArray = contract.isCompletedArray
        if let indexOfCheckedOfTask = contract.tasks.firstIndex(where: {$0 == task}) {
            print("Changing array from: \(editedCompletionArray) to:")
            editedCompletionArray[indexOfCheckedOfTask].toggle()
            print(editedCompletionArray)
            db.collection("users").document(userID).collection("contracts").document(contract.id).updateData([
                "completedTasks" : editedCompletionArray
            ])
        }
    }
    
    
    func approveManager(userID : String) {
        let userRef = db.collection("users")
        userRef.document(userID).updateData([
            "isTalentManager" : true,
            "managedInfluencers" : []
        ])
    }
    
    func declineManager(agencyID : String, userID : String) {
        let userRef = db.collection("agencies")
        userRef.document(agencyID).updateData([
            "talentManagers" : FieldValue.arrayRemove([userID])
        ])
        db.collection("users").document(userID).updateData([
            "agency" : "",
            "isTalentManager" : false
        ])
    }

    
    
    
    func setFirstName (id : String, name : String) {
        let userRef = db.collection("users")
        print("12Calling document: \(id)")
        userRef.document(id).updateData([
            "firstName": name,
            ])
    }
    
    func setLastName (id: String, name : String) {
        let userRef = db.collection("users")
        print("13Calling document: \(id)")
        userRef.document(id).updateData([
            "lastName": name,
            ])
    }
    
    func setTikTokUsername (id: String, username : String) {
        let userRef = db.collection("users")
        userRef.document(id).updateData([
            "tikTokUserName": username,
            ])
    }
    
    func setYoutubeUsername (id: String, username : String) {
        let userRef = db.collection("users")
        userRef.document(id).updateData([
            "youtubeUserName": username,
            ])
    }
    
    func setInstagramUsername (id: String, username : String) {
        let userRef = db.collection("users")
        userRef.document(id).updateData([
            "instagramUserName": username,
            ])
    }
    

    
    /// Takes an old contract, and takes updated fields. This will update the old contract in the databse and populate it with the new fields. This will in turn call listeners which will update the local copy of the contract as well.
    /// - Parameters:
    ///   - userID: user authentication ID
    ///   - contract: old Contract (needed for Contract ID)
    ///   - company: new company
    ///   - influencer: new influencer
    ///   - status: new status
    ///   - rate: new rate
    ///   - paymentStatus: new payment status
    ///   - postLink: new post link
    ///   - dueDate: new DueDate
    func editExistingContract (userID : String, contract : Contract, company : String, influencer : String, status : Contract.Progress, rate : Double?, paymentStatus : Contract.PaymentProgress, postLink : String?, dueDate : String?, tasks : [String], isCompletedArray : [Bool], influencerAssignedToContract : String?, attachments : [String], notes : String) {
        let unwrappedPostLink = returnUnwrappedOrEmptyString(optional: postLink)
        let unwrappedDueDate = returnUnwrappedOrEmptyString(optional: dueDate)
        var unwrappedRate : Double = 0
        if rate != nil {
            unwrappedRate = rate!
        }
        print("DataBaseServices updating status to \(status.rawValue)")
        print("15Calling document: \(userID)")
        
        let contractsRef = db.collection("users").document(userID).collection("contracts")
        print("16Calling document: \(contract.id)")
        contractsRef.document(contract.id).setData([
            "company" : company,
            "name" : influencer,
            "status" : AgencyViewModel.getStatus(contract: contract).rawValue,
            "rate" : unwrappedRate,
            "paymentStatus" : paymentStatus.rawValue,
            "postLink" : unwrappedPostLink,
            "dueDate" : unwrappedDueDate,
            "tasks" : tasks,
            "completedTasks" : isCompletedArray,
            "influencerAssignedToContract" : returnUnwrappedOrEmptyString(optional: influencerAssignedToContract),
            "notes" : notes,
            "attachments" : attachments
        ])
    }
    
    private func returnUnwrappedOrEmptyString (optional : String?) -> String {
        if optional != nil {
            return optional!
        } else {
            return ""
        }
    }
    
    func updateProfilePictureID (userID : String, pictureID : String) {
        db.collection("users").document(userID).updateData([
            "profilePictureID" : pictureID
        ])
    }
    
    func addAttachmentID (userID : String, contractID : String, attachmentID : String) {
        print("Adding New AttachmentID: \(attachmentID) contractID: \(contractID)")
        db.collection("users").document(userID).collection("contracts").document(contractID).updateData([
            "attachments" : FieldValue.arrayUnion([attachmentID])
        ])
    }
    
    func removeAttachmentID (userID : String, contractID : String, attachmentID : String) {
        db.collection("users").document(userID).collection("contracts").document(contractID).updateData([
            "attachments" : FieldValue.arrayRemove([attachmentID])
        ])
    }
    
    func getUserFromID (userID : String, localImageID : String, completion : @escaping (User) -> Void) {
        db.collection("users").document(userID).getDocument { document, error in
            var returnUser : User = User()
            var firstCompletion : Bool = false
            guard let document = document else {
                print("Error line 251 FireBaseDataServices")
                return
            }
            
            guard let data = document.data() else {
                print("Error line 255 FireBaseDataServices")
                return
            }
            
            if let firstName : String = data["firstName"] as? String {
                returnUser.firstName = firstName
            }
            
            if let lastName : String = data["lastName"] as? String {
                returnUser.lastName = lastName
            }
            
            if let email : String = data["email"] as? String {
                returnUser.email = email
            }
            
            if let isAgencyOwner : Bool = data["isAgencyOwner"] as? Bool {
                returnUser.isAgencyOwner = isAgencyOwner
            }
            
            if let isInfluencer : Bool = data["isInfluencer"] as? Bool {
                returnUser.isInfluencer = isInfluencer
            }
            
            if let isTalentManager : Bool = data["isTalentManager"] as? Bool {
                returnUser.IsTalentManager = isTalentManager
            }
            
            
            if let tikTokUserName : String = data["tikTokUserName"] as? String {
                if (tikTokUserName == "" || tikTokUserName == " ") {
                    returnUser.tikTokUserName = nil
                } else {
                    returnUser.tikTokUserName = tikTokUserName
                }
            }
            
            if let instagramUserName : String = data["instagramUserName"] as? String {
                if (instagramUserName == "" || instagramUserName == " ") {
                    returnUser.instagramUserName = nil
                } else {
                    returnUser.instagramUserName = instagramUserName
                }
            }
            
            if let youtubeUserName : String = data["youtubeUserName"] as? String {
                if (youtubeUserName == "" || youtubeUserName == " ") {
                    returnUser.youtubeUserName = nil
                } else {
                    returnUser.youtubeUserName = youtubeUserName
                }
            }
            
            if let notes : String = data["notes"] as? String {
                returnUser.notes = notes
            }
            
            if let managedInfluencerAsString : [String]? = data["managedInfluencers"] as? [String]? {
                returnUser.managedInfluencers = managedInfluencerAsString == nil ? [] : managedInfluencerAsString
            }
            
            returnUser.id = userID
            
            var needsDownload = false
            
            
            if let profilePictureID : String = data["profilePictureID"] as? String {
                needsDownload = !(localImageID == profilePictureID)
                print("Comparing local: \(localImageID) to remote \(profilePictureID)")
                
                if needsDownload {
                    print("NEEDS DOWNLOAD FOR \(userID)")
                    FireBaseStorageServices.shared.getProfilePicture(userID: userID)  {
                        exists, image in
                        
                        if exists {
                            if let image = image {
                                returnUser.profilePicture = image
                                DataManager.assignProfilePicID(userID: userID, context: self.delegate.persistentContainer.viewContext, newProfilePicID: profilePictureID)
                                DataManager.saveLocalProfilePic(userID: userID, image: image, context: self.delegate.persistentContainer.viewContext)
                            }
                        }
                        if firstCompletion {
                            completion(returnUser)
                        } else {
                            firstCompletion = true
                        }
                        
                    }
                } else {
                    print("\(returnUser.id)DOESN'T NEED DOWNLOAD USING LOCAL")
                    returnUser.profilePicture = DataManager.getLocalProfilPic(userID: returnUser.id, context: self.delegate.persistentContainer.viewContext) ?? UIImage.defaultImage
                    if firstCompletion {
                        completion(returnUser)
                    } else {
                        firstCompletion = true
                    }
                }
            } else {
                if firstCompletion {
                    completion(returnUser)
                } else {
                    firstCompletion = true
                }
            }
            

            
            
            self.db.collection("users").document(userID).collection("contracts").getDocuments {snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error line 288 FireBaseDataServices")
                    return
                }
            
                for document in documents {
                    let contract = Contract.toContractFromStringMap(id: document.documentID, stringMap: document.data())
                    returnUser.contracts.append(contract)
                }
                
                if firstCompletion {
                    completion(returnUser)
                } else  {
                    firstCompletion = true
                }
                
                
            }
            
            
        }
        
        
        
    }
    
    
    

    
    

    
}
