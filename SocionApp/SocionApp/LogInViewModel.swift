//
//  LoginViewModel.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 3/31/23.
//
import Foundation
import FirebaseAuth
import Firebase

class LogInViewModel: ObservableObject {
    @Published var credentials = AgencyCredentials()
    @Published var loading = false
    @Published var error : Authentication.AuthenticationError?
    @Published var data : FireBaseAuthServices?
    
    var loginDisable : Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    
    func logIn(completion: @escaping (Bool) -> Void) {
        loading = true
        //Unowned self to prevent memory leak
        FireBaseAuthServices.shared.logIn(credentials: credentials) { [unowned self] (result: Result<FireBaseAuthServices,Authentication.AuthenticationError>) in
            print("Logging In")
            loading = false
            //If successful, login, otherwise set credentials to ""
            switch result {
            case .success:
                print("Log in success")
                completion(true)
            case .failure(let error):
                self.error = error
                completion(false)
                print("Logging in unsuccess")
            }
        }
    }
}
