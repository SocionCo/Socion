//
//  Contract.swift
//  SocionDeadViews
//
//  Created by Ted Wind on 4/1/23.
//
import Foundation
import SwiftUI

/// This Contract struct is the model behind all instances of contracts within the app
struct Contract: Hashable, Identifiable {
    enum Progress: String, CaseIterable {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case done = "Done"
    }
    
    enum PaymentProgress : String, CaseIterable {
        case notPaid = "Not Paid"
        case paid = "Paid"
    }
    
    var id : String = UUID().uuidString
    var company : String = ""
    var rate : Double?
    var paymentStatus : PaymentProgress
    private var status: Progress
    var name : String = ""
    var postLink : String?
    var dueDate : Date?
    var tasks : [String] = []
    var isCompletedArray : [Bool] = []
    var influencerAssignedToContract : String?
    var notes : String = ""
    var attachments : [String] = []
    
    init(id : String, company: String, status: Contract.Progress, influencer: String, paymentStatus : Contract.PaymentProgress, postLink : String?, dueDate : Date?, rate : Double?, tasks : [String],  isCompletedArray : [Bool], influencerAssignedToContract : String?, attachments : [String], notes : String) {
        self.id = id
        self.company = company
        self.status = status
        self.name = influencer
        self.postLink = postLink
        self.dueDate = dueDate
        self.paymentStatus = paymentStatus
        self.rate = rate
        self.tasks = tasks
        self.isCompletedArray = isCompletedArray
        if influencerAssignedToContract == "" || influencerAssignedToContract == " " {
            self.influencerAssignedToContract = nil
        } else {
            self.influencerAssignedToContract = influencerAssignedToContract
        }
        self.attachments = attachments
        self.notes = notes
    }
    
    /// This function takes a String:Any map that has all of the appropriate fields, coming from the FireStore databse, and convert's it to a Contract object for use locally.
    /// - Parameters:
    ///   - id: contract ID (document.id in FireStore)
    ///   - stringMap: the String:Any map coming from FireStore
    /// - Returns: a contract generated from the information in the map
    static func toContractFromStringMap (id: String, stringMap : [String : Any]) -> Contract {
        let company = stringMap["company"] as! String
        let status = stringMap["status"] as! String
        let statusEnum : Progress = stringToStatus(stringStatus: status)
        let paymentStatus : PaymentProgress = paymentStringToStatus(stringStatus: stringMap["paymentStatus"] as! String)
        
        let rate : Double = stringMap["rate"] as! Double
        
        let influencer = stringMap["name"] as! String
        var dueDate : String? = nil
        if stringMap["dueDate"] != nil {
            dueDate = stringMap["dueDate"] as! String?
        }
        var postLink : String? = nil
        if stringMap["postLink"] != nil {
            postLink = stringMap["postLink"] as! String?
        }
        
        var unwrappedTasks : [String] = []
        if stringMap["tasks"] == nil {
            unwrappedTasks = []
        } else {
            unwrappedTasks = stringMap["tasks"] as! [String]
        }
        
        var unwrappedCompletion : [Bool] = []
        if stringMap["completedTasks"] == nil {
            unwrappedCompletion = []
        } else {
            unwrappedCompletion = stringMap["completedTasks"] as! [Bool]
        }
        
        var unwrappedInfluencerID : String? = nil
        if stringMap["influencerAssignedToContract"] != nil {
            unwrappedInfluencerID = stringMap["influencerAssignedToContract"] as! String?
        }
        
        var unwrappedNotes : String = ""
        if stringMap["notes"] != nil {
            unwrappedNotes = stringMap["notes"] as! String
        }
        
        var unwrappedAttachments : [String] = []
        if stringMap["attachments"] != nil {
            unwrappedAttachments = stringMap["attachments"] as! [String]
        }
        
        let contractToReturn = Contract(id: id, company: company, status: statusEnum, influencer: influencer, paymentStatus: paymentStatus, postLink: postLink, dueDate: Contract.stringToDateForStorage(stringDate: dueDate), rate: rate, tasks : unwrappedTasks, isCompletedArray: unwrappedCompletion, influencerAssignedToContract: unwrappedInfluencerID, attachments: unwrappedAttachments, notes: unwrappedNotes)
        return contractToReturn
    }
    
    /// Takes a date, and returns it in the string form of yyyy-MM-dd hh:mm:ss to be used for storage
    static func dateToStringForStorage(date : Date?) -> String? {
        if date == nil {
            return nil
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: date!)
        return now
    }
    
    static func timeUntilDate(date : Date?) -> String? {
        if let date = date {
            let diffs = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: date )
            if diffs.year == nil || diffs.month == nil || diffs.day == nil || diffs.hour == nil || diffs.minute == nil || diffs.second == nil {
                return nil
            }
            let total = diffs.year! + diffs.month! + diffs.day! + diffs.hour! + diffs.minute! + diffs.second!
    
            if ( total == 0 || total < 0) {
                return "Deadline Passed"
            }
            let years = diffs.year != 0 ? (diffs.year == 1 ? "\(diffs.year!) year" : "\(diffs.year!) years") : ""
            let months = diffs.month != 0 ? (diffs.month == 1 ? "\(diffs.month!) month" : "\(diffs.month!) months") : ""
            let days = diffs.day != 0 ? (diffs.day == 1 ? "\(diffs.day!) day" : "\(diffs.day!) days") : ""
            let hours = diffs.hour != 0 ? (diffs.hour == 1 ? "\(diffs.hour!) hour" : "\(diffs.hour!) hours") : ""
            let minutes = diffs.minute != 0 ? (diffs.minute == 1 ? "\(diffs.minute!) minute" : "\(diffs.minute!) minutes") : ""
            if (!(years == "" && days == "" && months == "")) {
                return ("\(years) \(months) \(days)")
            }
            return ("\(hours) \(minutes)")
            
            
        }
        return nil

    }
    
    
    /// Takes a Date and returns a string of just the year, month, and day. This form should just be used for presenting a string, not for store to FireBase
    /// - Parameter date: Date
    /// - Returns: display string
    static func dateToStringForPresentation (date : Date?) -> String? {
        if date == nil {
            return nil
        }
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let now = df.string(from: date!)
        return now
    }
    
    /// Takes a String in FireStore storage form, and returns a date object
    /// - Parameter stringDate: complete date string for Storage
    /// - Returns: Date object
    static func stringToDateForStorage(stringDate : String?) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyy-MM-dd hh:mm:ss"
        print("Input Date : \(stringDate!)")
        if stringDate == nil {
            print("Output Date: nil")
            return nil
        }
        
        let now = df.date(from: stringDate!)
        if (now == nil) {
            print("Error with date conversion")
        }
        print("Output date : \(now)")
        return now
    }
    
    
    /// Takes a string form of Status from the databse, converts it to Progress enum for local use
    /// - Parameter stringStatus: rawValue of Progress enum
    /// - Returns: Progress enum
    static func stringToStatus(stringStatus : String) -> Progress {
        var statusEnum : Progress = .notStarted
        switch stringStatus {
            case "Not Started":
                statusEnum = .notStarted

            case "In Progress":
                statusEnum = .inProgress

            case "Done":
                statusEnum = .done

            default:
                statusEnum = .notStarted
        }
        return statusEnum
    }
    
    static func paymentStringToStatus (stringStatus : String) -> PaymentProgress {
        var statusEnum : PaymentProgress = .notPaid
        
        switch stringStatus {
            case "Not Paid":
                statusEnum = .notPaid
            case "Paid":
                statusEnum = .paid
            default:
                statusEnum = .notPaid
        }
        return statusEnum
    }
    
    
    
    static func cutDownPresentationDate (date : String) -> String {
        let last2 = date.suffix(2)
        let firstpart = date.prefix(6)
        return String("\(firstpart)\(last2)")
    }
            
        
    
    static func statusColor(contract: Contract) -> Color {
        switch contract.getStatus() {
        case.notStarted:
            return Color(red: 232/255, green: 142/255, blue: 143/255)
        case .inProgress:
            return Color(UIColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1.0))
        case .done:
            return Color(red: 183/255, green: 215/255, blue: 181/255)
        }
    }
    
    static func paymentStatusColor(contract: Contract) -> Color {
        switch contract.paymentStatus {
        case.notPaid:
            return Color(red: 232/255, green: 142/255, blue: 143/255)
        case.paid:
            return Color(red: 183/255, green: 215/255, blue: 181/255)
        }
    }
    
    func getStatus() -> Contract.Progress {
        if AgencyViewModel.areAllTasksCompleted(contract: self) {
            return .done
        } else if AgencyViewModel.areAnyTasksCompleted(contract: self) {
            return .inProgress
        } else {
            return .notStarted
        }
    }
    
}
