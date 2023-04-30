//
//  ManageInfluencersView.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/7/23.
//

import SwiftUI

struct ManageInfluencersView: View {
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let backgroundColor = Color(red: 183/255, green: 235/255, blue: 181/255)
    let textColor = Color(red: 242/255, green: 242/255, blue: 247/255)
    let buttonColor = Color.green
    let pasteBoard = UIPasteboard.general
    @State private var inviteSheet : Bool = false
    @State private var linkCopied : Bool = false
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var tempUser : User = User()
    @State private var isPresentingConfirm : Bool = false
        
        var body: some View {
                VStack {
                    SearchBar(text: $searchText)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    
                    List(userViewModel.agencyViewModel.agency.influencers.filter {
                        searchText.isEmpty ? true : $0.getFullName().localizedStandardContains(searchText)
                    }, id: \.self) { influencer in
                        NavigationLink(destination: SocialMediaStats()) {
                            InfluencerRowView(influencer: influencer.getFullName())
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                    .background(backgroundColor.edgesIgnoringSafeArea(.all))
                }
                .navigationBarTitle("Influencers")
                .foregroundColor(textColor)
                .background(backgroundColor.edgesIgnoringSafeArea(.all))
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Dashboard")
                            }.foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu("Manage") {
                            Menu("Delete Influencer") {
                                ForEach(userViewModel.agencyViewModel.getInfluencers(), id: \.self) {
                                    influencer in
                                    Button {
                                        isPresentingConfirm = true
                                        tempUser = influencer
                                        userViewModel.agencyViewModel.removeInfluencerFromAgency(influencerID: tempUser.id)
                                    } label: {
                                        Text(influencer.getFullName())
                                    }
                                }
                            }
                            Button {
                                inviteSheet = true
                            } label: {
                                Text("Invite Influencer")
                            }
                            
                            
                           
                        }.foregroundColor(.white)
                    }
                }.sheet(isPresented: $inviteSheet){
                    ZStack {
                        VStack {
                            Text("Copy Agency Join Code Below")
                                .font(.headline)
                                .padding(.bottom, 20)
                            HStack {
                                TextField("Copy Join Code", text: $userViewModel.agencyViewModel.agency.id)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8.0)
                                    .padding(.bottom, 20)
                                    .disabled(true)
                                Image(systemName: "doc.on.clipboard.fill").onTapGesture {
                                    pasteBoard.string = userViewModel.user.agency
                                    print(userViewModel.agencyViewModel.agency.id)
                                    withAnimation {
                                        linkCopied = true
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            linkCopied = false
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16.0)
                        .padding(.horizontal, 20)
                        .presentationDetents([.fraction(0.4)])
                        if linkCopied {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                                .opacity(0.5)
                                .frame(width: 125, height: 100)
                                .overlay(
                                    VStack {
                                        Text("Link Copied")
                                    }
                                )
                        }
                    }
                }
            }
        }

    struct InfluencerRowView: View {
        let influencer: String
        let textColor = Color(red: 51/255, green: 51/255, blue: 51/255)
        let buttonColor = Color.green
        let backgroundColor = Color(red: 183/255, green: 235/255, blue: 181/255)
        var body: some View {
            HStack {
                Text(influencer)
                    .foregroundColor(.black)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                NavigationLink(destination: SocialMediaStats()) {}
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
        }
    }

    struct InfluencerDetailView: View {
        var body: some View {
            Text("Influencer Detail View")
                .font(.title)
                .fontWeight(.semibold)
        }
    }

    struct SearchBar: View {
        @Binding var text: String
        
        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $text)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 10)
        }
    }


