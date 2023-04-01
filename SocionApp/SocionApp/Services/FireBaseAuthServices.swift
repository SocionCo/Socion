//  FireBaseServices.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 3/31/23.
//
import Foundation
import Firebase
import FirebaseAuth

//This is an access point for all FireBase Auth services. This class is a singleton, which has one instance variable shared, through which everything is accessed. (Not actually sure if this is the smartest thing to do for FireBase but whatever).
class FireBaseAuthServices {
    
    static let shared = FireBaseAuthServices()
    
    
    func getLoggedInID () -> String? {
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        return userID
    }
    
    //Function to Register Asychronously
    func register(credentials : AgencyCredentials, completion : @escaping (Result<Bool,Authentication.AuthenticationError>) -> Void) {
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
    
    
    //Func to log in Asynchronously
    func logIn(credentials : AgencyCredentials, completion : @escaping (Result<FireBaseAuthServices,Authentication.AuthenticationError>) -> Void ) {
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
