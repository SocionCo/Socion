//
//  UserCredentials.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 3/31/23.
//

import Foundation

 

struct User : Hashable {
    var id : String = ""
    var firstName: String = ""
    var lastName: String = ""
    var password: String = ""
    var email : String = ""
    var contracts : [Contract] = []
    var isAgencyOwner : Bool = false
    var agency : String?
    var isInfluencer : Bool = false
    var IsTalentManager : Bool = false
    
    
    init(){}
    
    init(id: String, firstName: String, lastName: String, password: String, email: String, contracts: [Contract], isAgencyOwner: Bool, agency: String? = nil, isInfluencer: Bool, IsTalentManager: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.email = email
        self.contracts = contracts
        self.isAgencyOwner = isAgencyOwner
        self.agency = agency
        self.isInfluencer = isInfluencer
        self.IsTalentManager = IsTalentManager
    }
}
