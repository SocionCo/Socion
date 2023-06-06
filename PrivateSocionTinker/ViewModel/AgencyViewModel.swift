//
//  AgencyViewModel.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/7/23.
//

import Foundation
import SwiftUI
import CoreData
import PDFKit

class AgencyViewModel : ObservableObject {
    @Published var agency = Agency()
    var initialPop : Bool = true
    var influencersAddedToModel : Bool = false
    var talentManagersAddedToModel : Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var context : NSManagedObjectContext {
        delegate.persistentContainer.viewContext
    }
    
    func createAgencyForUser(userID : String, agencyName : String) -> String {
        return FireBaseDataServices.shared.startAgency(ownerId: userID, agencyName: agencyName)
    }
    
    
    //MARK: Agency Log-In Sequence
    
    /// Outermost function of the Log-In Sequence. This set's initialPop to true *this might be deprecated*, which stops the ContractListener from firing twice on the intial lod.
    /// - Parameter userViewModel: the userViewModel object
    func initiateAgencyListeners(userViewModel : UserViewModel) {
        self.initialPop = true
        self.attachAgencyInfoListeners(agencyID: userViewModel.user.agency!)
        self.attachInfluencerInfoListenersToAgency(agencyID: userViewModel.user.agency!) { influencers in
            print("INFLUENCERS SHOULD BE IN MODEL BY NOW")
            self.attachContractListeners(influencers: influencers)
            self.influencersAddedToModel = true
        }
        self.attachTalentManagerListenersToAgency(agencyID: userViewModel.user.agency!) { completion in
            print("NININININININ")
            self.talentManagersAddedToModel = true
        }
        
    }
    
    /// This attaches listeners to the agency info for everything besides Influencer's and Contarcts
    /// - Parameter agencyID: agencyID/DocumentID String
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
            
            self.agency.id = agencyID
            self.updateOnlyAgencyInfo(data: data)
        }
        
    }
    
    /// This function attaches Listeners to just the influencer information, including contracts on each Influencer User object, but doesn't attach any listeners to those contracts. These listeners are only called when a field in the user is updated.
    /// - Parameters:
    ///   - agencyID: agencyID String
    ///   - completion: completion that returns once all users have been initialized, to make sure that Contract listeners don't fire until all users have been added
    private func attachInfluencerInfoListenersToAgency(agencyID : String, completion :  @escaping ([String]) -> Void) {
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
            
            for influencerID in influencers {
                print("Adding listener to influencer")
                self.attachSnapshotListenerToInfluencer(userID: influencerID) {
                    if self.agency.influencers.count == influencers.count {
                        print("Finished adding influecers to model")
                        completion(influencers)
                    }
                }
            }
            
            
            
            
        }
    
    }
    
    
    
    
    private func attachTalentManagerListenersToAgency(agencyID : String,  completion : @escaping (Bool) -> Void) {
        FireBaseDataServices.shared.db.collection("agencies").document(agencyID).getDocument { document, error in
            
            guard let document = document else {
                print("Error line 59 AgencyViewModel")
                return
            }
            
            guard let data = document.data() else {
                print("Error line 64 AgencyViewModel")
                return
            }
            
            guard let talentManagers = data["talentManagers"] as? [String] else {
                print("Error line 69 AgencyViewModel")
                return
            }
            
            for talentManagerID in talentManagers {
                print("Adding listener to talent")
                self.attachSnapshotListenerToTalentManager(userID: talentManagerID) {
                    if self.agency.talentManagers.count == talentManagers.count {
                        
                        for var talentManager in self.agency.talentManagers {
                            FireBaseStorageServices.shared.getProfilePicture(userID: talentManager.id) {
                                exists, image in
                                
                                if exists {
                                    if let image = image {
                                        talentManager.profilePicture = image
                                    } else {
                                        print("Weird Error")
                                    }
                                } else {
                                    talentManager.profilePicture = UIImage.defaultImage
                                }
                            }
                        }
                        
                        
                        completion(true)
                    }
                }
            }
            
            if talentManagers.count == 0 && self.agency.talentManagers.count == 0 {
                completion(true)
            }
            
            
            
            
        }
    
    }
    
    
    
    /// Part of the attachInfluencerInfoListenersToAgency function, just adds the listeners to each individual and updatesUserInfo whenever something changes in the form of creating a new UserObject with the current database settings.
    /// - Parameters:
    ///   - userID: <#userID description#>
    ///   - completion: <#completion description#>
    private func attachSnapshotListenerToInfluencer (userID: String, completion : @escaping () -> Void) {
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
                    print("RemovingInfluencer2: \(self.agency.influencers[indexToRemove].getFullName())")
                    self.agency.influencers.remove(at:indexToRemove)
                }
            }
            
            
            
            
            FireBaseDataServices.shared.getUserFromID(userID: userID, localImageID: DataManager.getLocalProfilePicID(userID: userID, context: self.context) ?? "fail1"){newUser in
                print("Appending New User")
                if userExistsLocally || !self.influencersAddedToModel {
                    print("AddingInfluencer2: \(newUser.getFullName())")
                    self.agency.influencers.append(newUser)
                }
                completion()
            }
        }
    }
    
    
    private func attachSnapshotListenerToTalentManager (userID: String, completion : @escaping () -> Void) {
        FireBaseDataServices.shared.db.collection("users").document(userID).addSnapshotListener { snapshot, error in
            print("SNAPSHOTFORTALENTFIRED")
            var userToRemove : User
            var indexToRemove : Int?
            var userExistsLocally : Bool = false
            
            for currentTalentManager in self.agency.talentManagers {
                if currentTalentManager.id == userID {
                    userExistsLocally = true
                    userToRemove = currentTalentManager
                    indexToRemove = self.agency.talentManagers.firstIndex(of: userToRemove)
                }
            }
            
            if userExistsLocally {
                if let indexToRemove = indexToRemove {
                    self.agency.talentManagers.remove(at:indexToRemove)
                }
            }
            
            
            
            
            FireBaseDataServices.shared.getUserFromID(userID: userID, localImageID: DataManager.getLocalProfilePicID(userID: userID, context: self.context) ?? "fail2") {newUser in
                print("Appending New Talent Manager")
                if userExistsLocally || !self.talentManagersAddedToModel {
                    self.agency.talentManagers.append(newUser)
                }
                completion()
            }
        }
    }
    
    /// This should only run once all influencer objects have been added locally to agency.influencers. This attaches a contract listener to each contract owned by influencers in the agency. When it fires, it will find the influencer who's contract changed, and simply instantiate a new object of that influencer, and delete the old object of that listener in the agency.influencers array
    /// - Parameter influencers: An array of InfluencerID from the database, not a local one.
    private func attachContractListeners (influencers : [String]) {
        print("ATTACHING CONTRACT LISTENERS FOR FIRST TIME")
        for influencer in influencers {
            print("attaching to: \(influencer)")
            FireBaseDataServices.shared.db.collection("users").document(influencer).collection("contracts").addSnapshotListener { snapshot, error in
                if self.initialPop {
                    self.initialPop = false
                    return
                }
                
                print("Contract listener popped")
                print("Edit made to: \(influencer) ")
                print("Listing all influencers: ")
                for influencer in self.agency.influencers {
                    print(influencer)
                }
                var userToRemove : User = User()
                var userExistsLocally : Bool = false
                
                for currentInfluencer in self.agency.influencers {
                    print("Checking \(currentInfluencer.id) against \(influencer)")
                    if currentInfluencer.id == influencer {
                        print("They are the same")
                        userExistsLocally = true
                        userToRemove = currentInfluencer
                    }
                }
                
                if userExistsLocally {
                    print("Entered First Local Existence")
                    FireBaseDataServices.shared.getUserFromID(userID: influencer, localImageID: DataManager.getLocalProfilePicID(userID: userToRemove.id, context: self.context) ?? "fail3") {newUser in
                        print("New User Retrieved")
                        if userExistsLocally {
                            print("RemovingInfluencer3: \(userToRemove.getFullName())")
                            self.agency.influencers.removeAll(where: {$0 == userToRemove})
                            print("AddingInfluencer3: \(newUser.getFullName())")
                            self.agency.influencers.append(newUser)
                        }
                    }
                }
            }
        }
        
    }
    
    //MARK: Video Functions
    
    func deleteDraft (name : String, userID : String, contract : Contract) {
        guard userID != "" else {
            return
        }
        let index = contract.drafts.firstIndex(where: {$0 == name})
        if let index = index {
            var newDrafts = contract.drafts
            newDrafts.remove(at: index)
            var newApprovals = contract.approvals
            newApprovals.remove(at: index)
            var newApprovalNotes = contract.approvalNotes
            newApprovalNotes.remove(at: index)
            FireBaseDataServices.shared.editApprovals(contractID: contract.id, userID: userID, approvals: newApprovals, notes: newApprovalNotes, drafts: newDrafts)
            FireBaseStorageServices.shared.deleteVideo(contractID: contract.id, videoName: name)
        } else {
            print("Error finding contract")
            return
        }
        
    }
    
    func submitUpload (name : String, contract :  Contract, userID : String, completion : @escaping (Bool) -> () ) {
        guard userID != "" else {
            completion(false)
            return
        }
        if contract.drafts.contains(name) {
            print("Pick a unique video draft name")
            completion(false)
            return
        }
        var newApprovals : [Contract.Approval] = contract.approvals
        newApprovals.append(Contract.Approval.unreviewed)
        var newNotes : [String] = contract.approvalNotes
        newNotes.append("")
        var newDrafts = contract.drafts
        newDrafts.append(name)
        FireBaseDataServices.shared.editApprovals(contractID: contract.id, userID: userID, approvals: newApprovals, notes: newNotes, drafts: newDrafts)
        FireBaseStorageServices.shared.addVideo(contractID: contract.id, videoName: name)
    }
    
    func submitReview (draftName : String, contractID : String, userID : String, approval : Contract.Approval, notes : String, completion : @escaping (Bool) -> ()) {
        if let contract = self.getContractFromID(contractID: contractID) {
            if let index = contract.drafts.firstIndex(of: draftName) {
                var newApprovals = contract.approvals
                newApprovals[index] = approval
                var newNotes = contract.approvalNotes
                newNotes[index] = notes
                FireBaseDataServices.shared.editApprovals(contractID: contract.id, userID: userID, approvals: newApprovals, notes: newNotes, drafts: contract.drafts)
            } else {
                completion(false)
                return
            }
        } else {
            completion(false)
            return
        }
    }
    
   
    
    func approveDraft (contractID : String, draftName : String, notes : String) {
        if let user = self.getOwnerOfContract(contractID: contractID) {
            self.submitReview(draftName: draftName, contractID: contractID, userID: user.id, approval: .approved, notes: notes, completion: {_ in})
        } else {
            print("Error fetching UserID")
            return
        }
    }
    
    func rejectDraft (contractID : String, draftName : String, notes : String) {
        if let user = self.getOwnerOfContract(contractID: contractID) {
            self.submitReview(draftName: draftName, contractID: contractID, userID: user.id, approval: .rejected, notes: notes, completion: {_ in})
        } else {
            print("Error fetching UserID")
            return
        }
    }
    
    func setDraftToUnreviewed (contractID : String, draftName : String, notes : String) {
        if let user = self.getOwnerOfContract(contractID: contractID) {
            self.submitReview(draftName: draftName, contractID: contractID, userID: user.id, approval: .unreviewed, notes: notes, completion: {_ in})
        } else {
            print("Error fetching UserID")
            return
        }
    }
    
    func getApprovals (contractID : String) -> [Contract.Approval] {
        for contract in self.getContracts() {
            if contract.id == contractID {
                return contract.approvals
            }
        }
        return []
    }
    
    func getApprovalNotes (contractID : String) -> [String] {
        for contract in self.getContracts() {
            if contract.id == contractID {
                return contract.approvalNotes
            }
        }
        return []
    }


    
    func checkIfVideosExistLocallyAndDownload (contract : Contract, loaded : @escaping (Bool) -> ()) {
        var completionArray : [Bool] = [Bool](repeating: false, count: contract.drafts.count)
        for index in contract.drafts.indices {
            if !DocumentServices.videoExistsLocally(name:contract.drafts[index], contractID: contract.id) {
                FireBaseStorageServices.shared.getVideo(contractID: contract.id, videoName: contract.drafts[index], completion: {video in
                    completionArray[index] = true})
            } else {
                completionArray[index] = true
            }
            if (completionArray.allSatisfy({$0})) {
                loaded(true)
            }
        }
    }
    
    
    
    
    //MARK: PDF Functions
    private func pdfFromURL(string: URL) -> PDFDocument? {
        return PDFDocument(url: string)
    }
    
    func uploadPDFFromURL(url : URL, contract : Contract, userID : String,  completion : @escaping (BasicError) -> ()) {
        let name = url.lastPathComponent
        if contract.attachments.contains(name) {
            print("Already contains file name")
            completion(.error)
        } else {
            if let pdfDocument = PDFDocument(url: url) {
                DocumentServices.storePDF(url: url, name: name, contractID: contract.id)
                FireBaseDataServices.shared.addAttachmentID(userID: userID, contractID: contract.id, attachmentID: name)
                FireBaseStorageServices.shared.uploadFirestoragePDF(document: pdfDocument, name: name, contractID: contract.id)
                completion(.noError)
            } else {
                print("Document doesn't exist")
                completion(.error)
            }
        }
    }
    
    func deletePDF(name : String, userID : String, contract : Contract) {
        let currentURL = DocumentServices.getAttachmentsDirectory(contractID: contract.id, name: name)
        FireBaseStorageServices.shared.deleteFirestoragePDF(name: name, contractID: contract.id)
        FireBaseDataServices.shared.removeAttachmentID(userID : userID, contractID: contract.id, attachmentID: name)
        DocumentServices.deleteAttachmentFromDocuments(url: currentURL)
    }
    
    
    
    
    
    private func updateOnlyAgencyInfo (data : [String : Any]) {
        print("Updating agency info")
        
        if let name : String = data["name"] as? String {
            agency.name = name
        }
        
        if let owner : String = data["owner"] as? String {
            FireBaseDataServices.shared.getUserFromID(userID: owner, localImageID: DataManager.getLocalProfilePicID(userID: owner, context: self.context) ?? "default") {newUser in
                self.agency.owner = newUser
            }
        }
        
        
        if let newInfluencerArray : [String] = data["influencers"] as? [String] {
            
            let oldInfluencerIDArray = agency.influencers.map{$0.id}
            
            if newInfluencerArray.count != agency.influencers.count {
                if newInfluencerArray.count < agency.influencers.count {
                    
                    //This means influencer has been removed
                    for oldInfluencerID in oldInfluencerIDArray {
                        print("removingNewInfluencer")
                        if (!newInfluencerArray.contains(oldInfluencerID)) {
                            let userToRemove : Int = agency.influencers.firstIndex(where: {$0.id == oldInfluencerID})!
                            agency.influencers.remove(at: userToRemove)
                        }
                        
                    }
                }
                else if influencersAddedToModel && newInfluencerArray.count > agency.influencers.count {
                    //This means an influencer has been added
                    print("AddingNewInfluencerBaby")
                    for newInfluencerID in newInfluencerArray {
                        if (!oldInfluencerIDArray.contains(newInfluencerID)) {
                            FireBaseDataServices.shared.getUserFromID(userID: newInfluencerID, localImageID: DataManager.getLocalProfilePicID(userID: newInfluencerID, context: self.context) ?? "fail4") { newUser in
                                print("AddingInfluencer1 \(newUser.getFullName())")
                                self.agency.influencers.append(newUser)
                                self.attachSnapshotListenerToInfluencer(userID: newInfluencerID, completion: {})
                                self.attachContractListeners(influencers: [newUser.id])
                            }
                        }
                    }
                }
            }
            
            if let newTalentManagerArray : [String] = data["talentManagers"] as? [String] {
                print("Entered String Array")
                print("New Talent Manager Array:")
                print(newTalentManagerArray)
                print("Old Talent Manager Array:")
                print(agency.talentManagers.map({$0.id}))
                print("Boolean Result: \(self.talentManagersAddedToModel)")
                let oldTalentManagerIDArray = agency.talentManagers.map{$0.id}
                
                if newTalentManagerArray.count != agency.talentManagers.count {
                    if newTalentManagerArray.count < agency.talentManagers.count {
                        print("Talent Manager removed")
                        //This means talent manager has been removed
                        for oldtalentManagerID in oldTalentManagerIDArray {
                            if (!newTalentManagerArray.contains(oldtalentManagerID)) {
                                let userToRemove : Int = agency.talentManagers.firstIndex(where: {$0.id == oldtalentManagerID})!
                                agency.talentManagers.remove(at: userToRemove)
                            }
                            
                        }
                    }
                    else if talentManagersAddedToModel && newTalentManagerArray.count > agency.talentManagers.count {
                        //This means a talent manager has been added
                        print("newTalentManager")
                        for newTalentManagerID in newTalentManagerArray {
                            if (!oldTalentManagerIDArray.contains(newTalentManagerID)) {
                                print("Adding user")
                                FireBaseDataServices.shared.getUserFromID(userID: newTalentManagerID, localImageID: DataManager.getLocalProfilePicID(userID: newTalentManagerID, context: self.context) ?? "fail6") { newUser in
                                    self.agency.talentManagers.append(newUser)
                                    self.attachSnapshotListenerToTalentManager(userID: newTalentManagerID, completion: {})
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    //MARK: Task interactions
    
    func addTaskToContract (id : String, task : String, contract : Contract) {
        FireBaseDataServices.shared.addTasktoContract(userID: id, contract: contract, task: task)
    }
    
    func removeTaskfromContract (id : String, task : String,  contract : Contract) {
        FireBaseDataServices.shared.removeTaskFromContract(userID: id, contract: contract, task: task)
    }
    
    func toggleTask (id : String, task: String, contract : Contract) {
        FireBaseDataServices.shared.toggleTask(userID: id, contract: contract, task: task)
    }
    
    
    func isTaskCompleted(task: String, contract: Contract) -> Bool {
        let index = contract.tasks.firstIndex(where: {$0 == task})
        if index != nil {
            return contract.isCompletedArray[index!]
        }
        return false
    }
    
    static func areAllTasksCompleted(contract : Contract) -> Bool {
        for task in contract.isCompletedArray {
            if !task {
                return false
            }
        }
        return true
    }
    
    static func areAnyTasksCompleted(contract : Contract) -> Bool {
        for task in contract.isCompletedArray {
            if task {
                return true
            }
        }
        return false
    }
    
    static func areAllTasksCompleted(isCompletedArray : [Bool]) -> Bool {
        for task in isCompletedArray {
            if !task {
                return false
            }
        }
        return true
    }
    
    static func areAnyTasksCompleted(isCompletedArray : [Bool]) -> Bool {
        for task in isCompletedArray {
            if task {
                return true
            }
        }
        return false
    }
    
    static func getStatus (contract : Contract) -> Contract.Progress {
        if areAllTasksCompleted(contract: contract) {
            return .done
        } else if areAnyTasksCompleted(contract: contract) {
            return .inProgress
        } else {
            return .notStarted
        }
    }
    
    
    
    
    //MARK: Getters and Setters (Changers) for Agency
    
    
    
    //Talent Manager Changers
    func approveTalentManager (userID : String) {
        FireBaseDataServices.shared.approveManager(userID: userID)
    }
    
    func declineTalentManager (userID : String) {
        FireBaseDataServices.shared.declineManager(agencyID: agency.id, userID: userID)
    }
    
    func removeInfluencerFromAgency (influencerID : String) {
        FireBaseDataServices.shared.removeInfluencerFromAgency(agencyID: self.getAgencyID(), influencerID: influencerID)
    }
    
    func removeTalentManagerFromAgency (talentManagerID : String) {
        FireBaseDataServices.shared.removeTalentManagerFromAgency(agencyID: self.getAgencyID(), talentManagerID: talentManagerID)
    }
    
    func getAllTalentManagers () -> [User] {
        var returnArray : [User] = []
        
        for talentManager in agency.talentManagers {
            if (talentManager.IsTalentManager) {
                returnArray.append(talentManager)
            }
        }
        
        return returnArray
    }
    
    func assignInfluencerToTalentManager(talentManagerID : String, influencerID : String) {
        FireBaseDataServices.shared.addInfluencerToTalentManager(talentManagerID: talentManagerID, influencerID: influencerID)
    }
    
    func removeInfluencerFromTalentManager(talentManagerID : String, influencerID : String) {
        FireBaseDataServices.shared.removeInfluencerFromTalentManager(talentManagerID: talentManagerID, influencerID: influencerID)
    }
    
    func getAllRequests () -> [User] {
        var talentManagerArray : [User] = []
        
        for talentManager in agency.talentManagers {
            if (talentManager.IsTalentManager == false) {
                talentManagerArray.append(talentManager)
            }
        }
        return talentManagerArray
    }
    
    
    func getOwnerOfContract (contract : Contract) -> User? {
        for influencer in agency.influencers {
            for userContract in influencer.contracts {
                if contract == userContract {
                    return influencer
                }
            }
        }
        return nil
    }
    
    func getOwnerOfContract (contractID : String) -> User? {
        for influencer in agency.influencers {
            for userContract in influencer.contracts {
                if contractID == userContract.id {
                    return influencer
                }
            }
        }
        return nil
    }
    
    func getOwnerOfContract(contractID : String) -> String {
        for influencer in agency.influencers {
            for userContract in influencer.contracts {
                if contractID == userContract.id {
                    return influencer.id
                }
            }
        }
        return ""
    }
    
    func addContractToInfluencer (contract : Contract, influencerID : String) {
        FireBaseDataServices.shared.addContract(id: influencerID, contract: contract)
    }
    
    func deleteContractForAgency (contract: Contract) {
        let user = self.getOwnerOfContract(contract: contract)
        if let user = user {
            FireBaseDataServices.shared.deleteContract(userID: user.id, contract: contract)
        }
    }
    
    
    
    func editContractAsAgency (contract : Contract, company : String, influencer : String, status : Contract.Progress, dueDate : String?, rate : Double?, paymentStatus : Contract.PaymentProgress, postLink : String?, tasks: [String], isCompleted : [Bool], influencerAssignedToContract : String?, attachments : [String], notes : String, approvals : [Contract.Approval], drafts : [String], approvalNotes : [String] ) {
        let user = self.getOwnerOfContract(contract: contract)
        if let user = user {
            print("Updating contract status to \(status.rawValue)")
            FireBaseDataServices.shared.editExistingContract(userID: user.id, contract: contract, company: company, influencer: influencer, status: status, rate : rate, paymentStatus: paymentStatus, postLink: postLink, dueDate: dueDate, tasks: tasks, isCompletedArray: isCompleted, influencerAssignedToContract: influencerAssignedToContract, attachments: attachments, notes: notes, approvals: approvals, drafts: drafts, approvalNotes: approvalNotes)
        } else {
            print("Auth Issue")
        }
    }
    
    func updateContractPaymentStatus(userID : String, contract : Contract, newPaymentStatus : Contract.PaymentProgress) {
        FireBaseDataServices.shared.updateContractPaymentStatus(userID: userID, contract: contract, newPaymentStatus: newPaymentStatus)
    }
    
    func restoreContracts (contract : Contract) {
        let contractOwner : User? = self.getOwnerOfContract(contract: contract)
        if let contractOwner = contractOwner {
            FireBaseDataServices.shared.restoreContract(userID: contractOwner.id, contract: contract)
        }
    }
    
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
    
    func getContracts() -> [Contract] {
        var returnArray : [Contract] = []
        
        for influencer in agency.influencers {
            for contract in influencer.contracts {
                returnArray.append(contract)
            }
        }
        return returnArray
    }
    
    func getContractFromID (contractID : String) -> Contract? {
        for contract in self.getContracts() {
            if contract.id == contractID {
                return contract
            }
        }
        return nil
    }
    
    func getContracts (getCompletedContracts : Bool) -> [Contract] {
        var returnArrayCompleted : [Contract] = []
        var returnArrayIncompleted : [Contract] = []
        for contract in self.getContracts() {
            if contract.getStatus() == .done && contract.paymentStatus == .paid {
                returnArrayCompleted.append(contract)
            } else {
                returnArrayIncompleted.append(contract)
            }
        }
        return getCompletedContracts ? returnArrayCompleted : returnArrayIncompleted
    }
    
    func getInfluencersForManager (talentManager : User) -> [User] {
        var managedInfluencers : [User] = []
        if talentManager.managedInfluencers == nil {
            return []
        }
        for influencer in agency.influencers {
            if (talentManager.managedInfluencers!.contains(influencer.id)) {
                managedInfluencers.append(influencer)
            }
        }
        return managedInfluencers
    }
    
    func getContractsForManager(talentManager : User) -> [Contract] {
        var returnArray : [Contract] = []
        let managedInfluencers : [User] = getInfluencersForManager(talentManager: talentManager)
        for influencer in managedInfluencers {
            returnArray += influencer.contracts
        }
        return returnArray
        
    }
    
    func getContractsForManager(talentManager : User, getCompletedContracts : Bool) -> [Contract] {
        var completedReturnArray : [Contract] = []
        var incompletedReturnArray : [Contract] = []
        
        for contract in self.getContractsForManager(talentManager: talentManager) {
            if contract.paymentStatus == .paid && contract.getStatus() == .done {
                completedReturnArray.append(contract)
            } else {
                incompletedReturnArray.append(contract)
            }
        }
        
        return getCompletedContracts ? completedReturnArray : incompletedReturnArray
    }
    
    func getInfluencers() -> [User] {
        return agency.influencers
    }
}


enum BasicError : Error {
    case error
    case noError
}
