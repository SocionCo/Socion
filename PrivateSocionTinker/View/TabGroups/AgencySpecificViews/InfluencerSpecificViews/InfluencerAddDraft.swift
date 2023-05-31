//
//  AgentDraftDashboard.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 5/29/23.
//

import SwiftUI
import AVKit
import PhotosUI

struct InfluencerAddDraft: View {
    @State private var submitText = ""
    enum LoadState{
        case unknown, loading, loaded(Movie), failed
    }
    @State private var loadState = LoadState.unknown
    @State private var selectedItem : PhotosPickerItem?
    @State var contract : Contract
    @State var showAlert : Bool = false
    @EnvironmentObject var userViewModel : UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                switch loadState {
                case .unknown:
                    ZStack {
                        Color.gray.opacity(0.5)
                        Image(systemName: "video")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                case.loading:
                    ProgressView()
                case.loaded(let movie):
                    VideoPlayer(player: AVPlayer(url: movie.url))
                        .frame(width: 400, height: 400)
                case.failed:
                    Text("Import Failed")
                }
                
                PhotosPicker("Choose Video", selection: $selectedItem, matching: .videos)
                    .padding(12)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                
                
                
                Button(action: {
                    userViewModel.agencyViewModel.submitUpload(name: submitText, contract: contract, userID: userViewModel.getID() ?? "") {
                        completion in
                        if !completion {
                            self.showAlert = true
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Submit")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
        }
        .padding()
        .navigationBarTitle("Upload Video")
        .onChange(of: selectedItem) { _ in
            Task {
                do {
                    loadState = .loading
                    
                    if let movie = try await selectedItem?.loadTransferable(type: Movie.self) {
                        let name : String =  UUID().uuidString
                        submitText = name
                        DocumentServices.storeVideo(url: movie.url, name: submitText, contractID: contract.id) { completion in
                            if completion {
                                print("Completion Successful")
                                DocumentServices.getVideoFromLocalStorage(name: submitText, contractID: contract.id) { returnMovie in
                                    
                                    loadState = .loaded(returnMovie)
                                }
                            } else {
                                print("Completion Failed MOFO")
                            }
                        }
                        
                    } else {
                        loadState = .failed
                    }
                } catch {
                    loadState = .failed
                }
            }
        }
        .alert("Error uploading video. Video name may not be unique.", isPresented: $showAlert) {
            Button("Ok", role: .cancel) {}
        }
    }
}



struct Movie : Transferable {
    
    let url : URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { recieved in
            let copy = URL.documentsDirectory.appending(path:"movie.mp4")
            if FileManager.default.fileExists(atPath: copy.path()) {
                try FileManager.default.removeItem(at: copy)
            }
            try FileManager.default.copyItem(at: recieved.file, to: copy)
            return Self.init(url: copy)
        }
    }
}
