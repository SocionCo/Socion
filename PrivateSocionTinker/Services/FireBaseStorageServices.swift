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
    
    func getProfilePicture (userID : String,  exists : @escaping (Bool,UIImage?) -> ()) {
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
}
