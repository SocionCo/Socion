//
//  ModelView.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/11/23.
//
import SwiftUI

struct ModelView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @ObservedObject var agencyViewModel : AgencyViewModel
    var body: some View {
        HStack {
            VStack {
                Group {
                    Text("User: ")
                    Text("Name: \(userViewModel.getName())")
                    Text("Email: \(userViewModel.user.email)")
                    Text("isAgencyOwner: \(String(userViewModel.user.isAgencyOwner))")
                    Text("isTalentManager: \(String(userViewModel.user.IsTalentManager))")
                    Text("isAgencyOwner: \(String(userViewModel.user.isAgencyOwner))")
                    Text("tikTokUserName: \(userViewModel.user.tikTokUserName ?? " ")")
                    Text("youtubeUserName: \(userViewModel.user.youtubeUserName ?? " ")")
                    Text("instagramUserName: \(userViewModel.user.instagramUserName ?? " ")")
                }
                if userViewModel.user.agency != nil {
                    Text("Owned Agency: \(String(userViewModel.user.agency!))")
                }
                Text("Campaigns: ")
                ForEach(userViewModel.user.contracts, id: \.self) { contract in
                    Text("Campaign: \(contract.name)")
                        Text("Tasks: ")
                        ForEach (contract.tasks, id: \.self) { task in
                            Text("Task: \(task)")
                            Text("Completed: \(String(contract.isCompletedArray[0]))")
                        }
                    }
                }
            
            if userViewModel.user.isInfluencer || userViewModel.user.IsTalentManager || userViewModel.user.isAgencyOwner {
                VStack {
                    Text("Agency Info: ").onTapGesture {
                        print("Agency Name: \(userViewModel.agencyViewModel.getAgencyName())")
                    }
                    Text("Name: \(userViewModel.agencyViewModel.agency.name)")
                    Text("Owner: \(userViewModel.agencyViewModel.agency.owner.firstName)")
                    Text("Influencers:")
                    ForEach(userViewModel.agencyViewModel.agency.influencers, id: \.self) { influencer in
                        Text("\(influencer.firstName)")
                        Text("\(influencer.lastName)")
                    }
                    if (userViewModel.user.IsTalentManager) {
                        Text("Manages:")
                        if (userViewModel.user.managedInfluencers != nil) {
                            Text(userViewModel.user.managedInfluencers!.description)
                        } else {
                            Text("Click Here For Updates").onTapGesture {
                                if userViewModel.user.managedInfluencers != nil {
                                    print(userViewModel.user.managedInfluencers!.description)
                                }
                            }
                        }
                    }
                }
            }
        }.onTapGesture {
            print("Requests:")
            print(agencyViewModel.getAllRequests())
            print("Managers:")
            print(agencyViewModel.getAllTalentManagers())
        }
    }
}
