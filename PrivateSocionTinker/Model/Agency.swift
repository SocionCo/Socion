//
//  Agency.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 4/7/23.
//

import Foundation

 
struct Agency {
    var id : String = ""
    var name: String = ""
    var owner : User = User()
    var talentManagers : [User] = []
    var influencers : [User] = []
    
    init(){}
    
    init(id: String, name: String, owner: User, talentManagers: [User], influencers: [User]) {
        self.id = id
        self.name = name
        self.owner = owner
        self.talentManagers = talentManagers
        self.influencers = influencers
    }
}


