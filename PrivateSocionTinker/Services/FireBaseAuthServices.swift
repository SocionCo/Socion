//
//  FireBaseServices.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 3/31/23.
//

import Foundation
import Firebase
import FirebaseAuth



//This is an access point for all FireBase Auth services. This class is a singleton, which has one instance variable shared, through which everything is accessed. Error handling is also done within this class with the use of the Authentication.Error class
class FireBaseAuthServices {
    
    static let shared = FireBaseAuthServices()
    
    
    func getLoggedInID () -> String? {
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        return userID
    }
    
    
    /// This function does the actual call to the FireBase authentication cloud, and registers a user.
    /// - Parameters:
    ///   - credentials: This is an instance of  user, must be populated with username and password at the time
    ///   - completion: Success or Failure of registration callback
    func register(credentials : User, completion : @escaping (Result<Bool,Authentication.AuthenticationError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error as NSError? {
                    guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
                        print("Error logging in, didn't match with a firebase code")
                        return
                    }
                    switch errorCode {
                        case .invalidEmail:
                            completion(.failure(.invalidEmail))
                        case .accountExistsWithDifferentCredential:
                            completion(.failure(.accountExistsWithDifferentCredential))
                        case .adminRestrictedOperation:
                            completion(.failure(.adminRestrictedOperation))
                        case .appNotAuthorized:
                            completion(.failure(.appNotAuthorized))
                        case .appNotVerified:
                            completion(.failure(.appNotVerified))
                        case .appVerificationUserInteractionFailure:
                            completion(.failure(.appVerificationUserInteractionFailure))
                        case .captchaCheckFailed:
                            completion(.failure(.captchaCheckFailed))
                        case .credentialAlreadyInUse:
                            completion(.failure(.credentialAlreadyInUse))
                        case .customTokenMismatch:
                            completion(.failure(.customTokenMismatch))
                        case .emailAlreadyInUse:
                            completion(.failure(.emailAlreadyInUse))
                        case .dynamicLinkNotActivated:
                            completion(.failure(.dynamicLinkNotActivated))
                        case .emailChangeNeedsVerification:
                            completion(.failure(.emailChangeNeedsVerification))
                        case .expiredActionCode:
                            completion(.failure(.expiredActionCode))
                        case .gameKitNotLinked:
                            completion(.failure(.gameKitNotLinked))
                        case .internalError:
                            completion(.failure(.internalError))
                        case .invalidAPIKey:
                            completion(.failure(.invalidAPIKey))
                        case .wrongPassword:
                            completion(.failure(.wrongPassword))
                        case .weakPassword:
                            completion(.failure(.weakPassword))
                        case .userNotFound:
                            completion(.failure(.userNotFound))
                        case .userMismatch:
                            completion(.failure(.userMismatch))
                        case .unverifiedEmail:
                            completion(.failure(.unverifiedEmail))
                        case .missingEmail:
                            completion(.failure(.missingEmail))
                        default:
                            completion(.failure(.deffy))
                        }
                } else {
                    completion(.success(true))
                    
                    print("Success")
                }
            }
        }
    }
    
    
    
    /// This function log's a user in, does the actual call to FireBase authentication
    /// - Parameters:
    ///   - credentials: User instance that must have a username and password. The user instance will not have anything else because that all still has to be downloaded from DataBase.
    ///   - completion: Callback containing success or failure
    func logIn(credentials : User, completion : @escaping (Result<FireBaseAuthServices,Authentication.AuthenticationError>) -> Void ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { [weak self] authResult, error in
                guard let strongSelf = self else {return}
                if let error = error as NSError? {
                    guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
                        print("Error logging in, didn't match with a firebase code")
                        return
                    }
                    
                    switch errorCode {
                        case .invalidEmail:
                            completion(.failure(.invalidEmail))
                        case .accountExistsWithDifferentCredential:
                            completion(.failure(.accountExistsWithDifferentCredential))
                        case .adminRestrictedOperation:
                            completion(.failure(.adminRestrictedOperation))
                        case .appNotAuthorized:
                            completion(.failure(.appNotAuthorized))
                        case .appNotVerified:
                            completion(.failure(.appNotVerified))
                        case .appVerificationUserInteractionFailure:
                            completion(.failure(.appVerificationUserInteractionFailure))
                        case .captchaCheckFailed:
                            completion(.failure(.captchaCheckFailed))
                        case .credentialAlreadyInUse:
                            completion(.failure(.credentialAlreadyInUse))
                        case .customTokenMismatch:
                            completion(.failure(.customTokenMismatch))
                        case .emailAlreadyInUse:
                            completion(.failure(.emailAlreadyInUse))
                        case .dynamicLinkNotActivated:
                            completion(.failure(.dynamicLinkNotActivated))
                        case .emailChangeNeedsVerification:
                            completion(.failure(.emailChangeNeedsVerification))
                        case .expiredActionCode:
                            completion(.failure(.expiredActionCode))
                        case .gameKitNotLinked:
                            completion(.failure(.gameKitNotLinked))
                        case .internalError:
                            completion(.failure(.internalError))
                        case .invalidAPIKey:
                            completion(.failure(.invalidAPIKey))
                        case .wrongPassword:
                            completion(.failure(.wrongPassword))
                        case .weakPassword:
                            completion(.failure(.weakPassword))
                        case .userNotFound:
                            completion(.failure(.userNotFound))
                        case .userMismatch:
                            completion(.failure(.userMismatch))
                        case .unverifiedEmail:
                            completion(.failure(.unverifiedEmail))
                        case .missingEmail:
                            completion(.failure(.missingEmail))
                        default:
                            completion(.failure(.deffy))
                        }
                    } else {
                        print("Success")
                        completion(.success(strongSelf))
                    }
                }
            }
        }
    }
