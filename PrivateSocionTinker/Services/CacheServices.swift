////
////  CacheServices.swift
////  PrivateSocionTinker
////
////  Created by Daniel Biundo on 5/26/23.
////
//
//import Foundation
//import SwiftUI
//import UIKit
//import PDFKit
//
//final class CacheServices {
//
//    static let cache = NSCache<NSString, PDFDocument>()
//
//    static func retrievePDF(name : String, contractID : String, completion : @escaping (PDFDocument?) -> ()) {
//        if let returnPDF = CacheServices.cache.object(forKey: NSString(string: name)) {
//            print("Retrieved from cache")
//            completion(returnPDF)
//        } else {
//            print("Not in cache, need from database")
//            FireBaseStorageServices.shared.getPDF(contractID: contractID, documentName: name) {
//                pdfDocument in
//
//                if let returnPDF : PDFDocument = pdfDocument {
//                    completion(returnPDF)
//                    CacheServices.cache.setObject(returnPDF, forKey: NSString(string: name))
//                } else {
//                    print("Error fetching PDF")
//                    completion(nil)
//                }
//            }
//        }
//
//
//    }
//
//    static func storePDF(document : PDFDocument, name : String, contract : Contract, userID : String) {
//        let contractID = contract.id
//        guard !contract.attachments.contains(name) else {
//            print("Attachment name already exists")
//            return
//        }
//        print("Store PDF Recieved Document. Name:\(name)")
//        FireBaseStorageServices.shared.uploadFirestoragePDF(document: document, name: name, contractID: contractID)
//        FireBaseDataServices.shared.addAttachmentID(userID: userID, contractID: contractID, attachmentID: name)
//        let nameAsNSString = NSString(string: name)
//        CacheServices.cache.setObject(document, forKey: nameAsNSString)
//    }
//
//}
