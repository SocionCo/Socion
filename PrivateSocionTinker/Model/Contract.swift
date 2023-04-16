//
//  Contract.swift
//  SocionDeadViews
//
//  Created by Ted Wind on 4/1/23.
//
import Foundation

/// This Contract struct is the model behind all instances of contracts within the app
struct Contract: Hashable {
    enum Progress: String, CaseIterable {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case done = "Done"
    }
    
    var id : String = UUID().uuidString
    var company : String = ""
    var rate : Double?
    var paymentStatus : Progress
    var status: Progress
    var name : String = ""
    var postLink : String?
    var dueDate : Date?
    
    init(id : String, company: String, status: Contract.Progress, influencer: String, paymentStatus : Contract.Progress, postLink : String?, dueDate : Date?, rate : Double?) {
        self.id = id
        self.company = company
        self.status = status
        self.name = influencer
        self.postLink = postLink
        self.dueDate = dueDate
        self.paymentStatus = paymentStatus
        self.rate = rate
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
        let paymentStatus : Progress = stringToStatus(stringStatus: stringMap["paymentStatus"] as! String)
        
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
        let contractToReturn = Contract(id: id, company: company, status: statusEnum, influencer: influencer, paymentStatus: paymentStatus, postLink: postLink, dueDate: Contract.stringToDateForStorage(stringDate: dueDate), rate: rate)
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
        df.dateFormat = "yyyy-MM-dd"
        let now = df.string(from: date!)
        return now
    }
    
    /// Takes a String in FireStore storage form, and returns a date object
    /// - Parameter stringDate: complete date string for Storage
    /// - Returns: Date object
    static func stringToDateForStorage(stringDate : String?) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyy-MM-dd hh:mm:ss"
        if stringDate == nil {
            return nil
        }
        let now = df.date(from: stringDate!)
        if (now == nil) {
            print("Error with date conversion")
        }
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
    
}
