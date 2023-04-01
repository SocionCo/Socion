//
//  LoginViewModel.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 3/31/23.
//
import Foundation
import FirebaseAuth
import Firebase

class RegisterViewModel: ObservableObject {
    @Published var credentials = AgencyCredentials()
    @Published var loading = false
    @Published var error : Authentication.AuthenticationError?
    @Published var hasError : Bool = false
    
    var registerDisable : Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    
    func register(completion: @escaping (Bool) -> Void) {
        loading = true
        //Unowned self to prevent memory leak
        FireBaseAuthServices.shared.register(credentials: credentials) { [unowned self] (result: Result<Bool,Authentication.AuthenticationError>) in
            loading = false
            //If successful, login, otherwise set credentials to ""
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                self.error = error
                completion(false)
            }
        }
    }
}
