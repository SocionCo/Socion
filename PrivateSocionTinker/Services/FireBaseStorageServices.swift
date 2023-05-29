//
//  FireBaseStorageServices.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 5/18/23.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftUI
import FirebaseCore
import FirebaseStorage
import PDFKit

class FireBaseStorageServices {
    
    static let shared = FireBaseStorageServices()
    let storageRef = Storage.storage().reference()
    
    func uploadProfilePicture(image : UIImage, userID : String) {
        let data : Data = image.pngData() ?? Data()
        let profilePicRef = storageRef.child("\(userID)/profilePicture.jpg")
        
        profilePicRef.putData(data, metadata: nil) { (metadata,error) in
            guard let _ = metadata else {
                print("Failure With MetaData")
                return
            }
        }
        
    }
    
    func uploadFirestoragePDF (document : PDFDocument, name : String, contractID : String) {
        let attachmentRef  = storageRef.child("\(contractID)/\(name)")
        if let document = document.dataRepresentation() {
            attachmentRef.putData(document, metadata: nil) {
                (metadata,error) in
                guard let _ = metadata else {
                    print("Failure with metadata")
                    return
                }
            }
        } else {
            print("Failure with conversion")
        }
    }
    
    func deleteFirestoragePDF (name : String, contractID : String) {
        let attachmentRef = storageRef.child("\(contractID)/\(name)")
        attachmentRef.delete { error in
            if let error = error {
                print("Unsuccessful deletion")
                print("\(error.localizedDescription)")
            } else {
                print("Successful deletion")
            }
        }
    }
    
    
    
    func getProfilePicture (userID : String,  exists : @escaping (Bool,UIImage?) -> ()) {
        print("Downloading Brand New PFP")
        let profilePicRef = storageRef.child("\(userID)/profilePicture.jpg")
        profilePicRef.getData(maxSize: 200 * 1024 * 1024) {
            data, error in
            print("Getting PFP for: \(userID)")
            if let error = error {
                exists(false,nil)
                print(error)
            } else {
                if let data = data {
                    let image = UIImage(data: data)
                    exists(true,image)
                }
            }
        }
    }
    
    func getPDF (contractID : String, documentName : String, completion : @escaping (PDFDocument?) -> ()) {
        let attachmentRef  = storageRef.child("\(contractID)/\(documentName)")
        attachmentRef.getData(maxSize: 1000 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
                completion(nil)
            } else {
                if let data = data {
                    if let returnPDF = PDFDocument(data: data) {
                        print("Successful PDF Conversion")
                        completion(returnPDF)
                    } else {
                        print("Unsuccessful PDF Conversion")
                        completion(nil)
                    }
                } else {
                    print("Failed data unpacking")
                    completion(nil)
                }
            }
            
        }
    }
}
