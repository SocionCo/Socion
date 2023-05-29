//
//  DataManager.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 5/25/23.
//

import Foundation
import CoreData
import UIKit

open class DataManager : NSObject {
    
    static let shared : DataManager = DataManager()
    
    static func getUser (userID : String, context : NSManagedObjectContext) -> NSManagedObject?  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalUser")
        request.predicate = NSPredicate(format: "id = %@", userID)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let profilePicID = (try? context.fetch(request)) ?? []
        if let returnId = profilePicID as? [NSManagedObject] {
            if returnId.count > 0 {
                return returnId[0]
            } else {
                DataManager.startUser(userID: userID, context: context)
            }
        }
        return nil
    }
    
    static func getLocalProfilePicID (userID : String, context : NSManagedObjectContext) -> String? {
        if let returnID = DataManager.getUser(userID: userID, context: context) {
                return returnID.value(forKey: "profilePictureID") as? String
        } else {
            print("Error couldn't find user")
            return nil
        }
        
    }
    
    static func assignProfilePicID (userID : String, context : NSManagedObjectContext, newProfilePicID : String) {
        if let user = DataManager.getUser(userID: userID, context: context) {
            user.setValue(newProfilePicID, forKey: "profilePictureID")
            print("Set PPID to \(newProfilePicID)")
        } else {
            print("PPID failed")
        }
        if let error = context.saveIfChanged() {
            print(error)
        }
    }
    
    static func saveLocalProfilePic(userID : String, image : UIImage, context : NSManagedObjectContext) {
        if let user = DataManager.getUser(userID: userID, context: context) {
            let data = image.jpegData(compressionQuality: 1.0)
            user.setValue(data, forKey: "profilePicture")
            if let error = context.saveIfChanged() {
                print(error)
            }
        }
    }
    
    static func getLocalProfilPic (userID : String, context : NSManagedObjectContext) -> UIImage? {
        if let user = DataManager.getUser(userID: userID, context: context) {
            if let data = user.value(forKey: "profilePicture") as? Data {
                let image = UIImage(data: data)
                return image
            }
        }
        print("Error in conversion")
        return nil
    }
    
    static func startUser (userID : String, context: NSManagedObjectContext) {
        let newUser = LocalUser(context: context)
        newUser.id = userID
        newUser.profilePictureID = "default"
        if let error = context.saveIfChanged() {
            print(error)
        }
    }
    
    
}
