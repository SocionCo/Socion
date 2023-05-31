//
//  DocumentServices.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 5/29/23.
//

import Foundation
import PDFKit
import AVFoundation

struct DocumentServices {
    
    static func getAttachmentsDirectory(contractID : String, name : String) -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0].appendingPathComponent("\(contractID)-\(name)")
    }
    
    static func getDraftVideoDirectory(contractID : String, name : String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0].appendingPathComponent("\(contractID)-video-\(name).mp4")
    }
    
    static func getVideoAsData (name : String, contractID : String) -> Data? {
        let url = DocumentServices.getDraftVideoDirectory(contractID: contractID, name: name)
        let data = FileManager.default.contents(atPath: url.path(percentEncoded: true))
        guard let data = data else {
            print("Data was nil")
            return nil
        }
        return data
    }
    
    static func storePDF (url : URL, name : String, contractID : String) {
        let newUrl = DocumentServices.getAttachmentsDirectory(contractID: contractID, name: name)
        let pdf = PDFDocument(url: url)
        if let pdf = pdf {
            pdf.write(to: newUrl)
            print("Writing successful")
        }
    }
    
    static func storeVideo (url : URL, name : String, contractID : String, completion : @escaping (Bool) -> ()) {
        let newUrl = DocumentServices.getDraftVideoDirectory(contractID: contractID, name: name)
        print("NewURL: \(newUrl)")
        do {
            if FileManager.default.fileExists(atPath: newUrl.path(percentEncoded: true)) {
                print("File Already Exists at \(newUrl.path(percentEncoded: true))")
                print("Trying to delete file")
                try FileManager.default.removeItem(atPath: newUrl.path(percentEncoded: true))
                try FileManager.default.moveItem(at: url, to: newUrl)
                completion(true)
            } else {
                try FileManager.default.moveItem(at: url, to: newUrl)
                print("Successfull storage of video to url \(newUrl)")
                completion(true)
            }
        } catch {
            print("\(error.localizedDescription)")
            completion(false)
        }
    }
    
    static func storeVideo (name : String, contractID : String, data : Data) -> URL{
        let newUrl : URL = DocumentServices.getDraftVideoDirectory(contractID: contractID, name: name)
        FileManager.default.createFile(atPath: newUrl.path(percentEncoded: true), contents: data)
        return newUrl
    }
    
    static func getVideoFromLocalStorage (name : String, contractID : String, completion : @escaping (Movie) -> ()) {
        let url = DocumentServices.getDraftVideoDirectory(contractID: contractID, name: name)
        let video = Movie(url: URL(filePath: url.path(percentEncoded: true)))
        print("Retrieved video from : \(url)")
        completion(video)
        
    }
    
    static func getVideoLocallyOrDownload (name : String, contractID : String, completion : @escaping (Movie) -> ()) {
        let url = DocumentServices.getDraftVideoDirectory(contractID: contractID, name: name)
        if FileManager.default.fileExists(atPath: url.path(percentEncoded: true))  {
            DocumentServices.getVideoFromLocalStorage(name: name, contractID: contractID) {
                movie in
                completion(movie)
            }
        } else {
            
        }
    }
    
    
    static func retrievePDFFromFileorFireStorage (name : String, contractID : String, completion : @escaping (PDFDocument?, URL?) -> ()) {
        let url = DocumentServices.getAttachmentsDirectory(contractID: contractID, name: name)
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
    
    static func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func videoExistsLocally (name : String, contractID : String) -> Bool {
        return FileManager.default.fileExists(atPath: DocumentServices.getDraftVideoDirectory(contractID: contractID, name: name).path(percentEncoded: true))
    }
    
}
