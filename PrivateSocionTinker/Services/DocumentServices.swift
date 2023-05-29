//
//  DocumentServices.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 5/29/23.
//

import Foundation
import PDFKit


struct DocumentServices {
    
    static func getDocumentsDirectory(contractID : String, name : String) -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0].appendingPathComponent("\(contractID)-\(name)")
    }
    
    
    static func storePDF (url : URL, name : String, contractID : String) {
        let newUrl = DocumentServices.getDocumentsDirectory(contractID: contractID, name: name)
        let pdf = PDFDocument(url: url)
        if let pdf = pdf {
            pdf.write(to: newUrl)
            print("Writing successful")
        }
    }
    
    
    static func retrievePDFFromFileorFireStorage (name : String, contractID : String, completion : @escaping (PDFDocument?, URL?) -> ()) {
        let url = DocumentServices.getDocumentsDirectory(contractID: contractID, name: name)
        let pdf = PDFDocument(url: url)
        if let pdf = pdf {
            completion(pdf, url)
        } else {
            print("Not found locally, sending FireStorage")
            FireBaseStorageServices.shared.getPDF(contractID: contractID, documentName: name) {pdfDocument in
                if let pdfDocument = pdfDocument {
                    print("Successfully pulled from FireStorage")
                    pdfDocument.write(to: url)
                    completion(pdfDocument, url)
                } else {
                    print("Failed FireStorage pull")
                    completion(nil, nil)
                }
            }
        }
    }
    
    static func deleteAttachmentFromDocuments (url : URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print("Could delete file. \(error.localizedDescription)")
        }
    }
    
}
