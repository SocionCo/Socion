//
//  Authentication.swift
//  PrivateSocionTinker
//
//  Created by Daniel Biundo on 3/31/23.
//

import SwiftUI



/// Class that handles Authentication. In the outer app file, as soon as inValidated becomes false, the user is returned to the main log in screen. A copy of Authentication is injected into every view through EnviromentObject.
class Authentication: ObservableObject {
    @Published var isValidated : Bool = false
    
    /// This enum handles all relevant possible AuthenticationErrors, and gives them all their own custom error messages.
    enum AuthenticationError : Error, LocalizedError, Identifiable {
        case invalidRegistration
        case invalidLogIn
        case invalidEmail
        case accountExistsWithDifferentCredential
        case adminRestrictedOperation
        case appNotAuthorized
        case appNotVerified
        case appVerificationUserInteractionFailure
        case captchaCheckFailed
        case credentialAlreadyInUse
        case customTokenMismatch
        case emailAlreadyInUse
        case dynamicLinkNotActivated
        case emailChangeNeedsVerification
        case expiredActionCode
        case gameKitNotLinked
        case internalError
        case invalidAPIKey
        case wrongPassword
        case weakPassword
        case userNotFound
        case userMismatch
        case unverifiedEmail
        case missingEmail
        case deffy
        
        var id : String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
                case .invalidEmail:
                    return NSLocalizedString("Invalid Email", comment: "")
                case .accountExistsWithDifferentCredential:
                    return NSLocalizedString("Account exists with different credential", comment: "")
                case .adminRestrictedOperation:
                    return NSLocalizedString("Admin restricted operation", comment: "")
                case .appNotAuthorized:
                    return NSLocalizedString("App not authorized.", comment: "")
                case .appNotVerified:
                    return NSLocalizedString("App not verified.", comment: "")
                case .appVerificationUserInteractionFailure:
                    return NSLocalizedString("App verification user interaction failure", comment: "")
                case .captchaCheckFailed:
                    return NSLocalizedString("Captcha check failed.", comment: "")
                case .credentialAlreadyInUse:
                    return NSLocalizedString("Credential already in use.", comment: "")
                case .customTokenMismatch:
                    return NSLocalizedString("Custom token mismatch.", comment: "")
                case .emailAlreadyInUse:
                    return NSLocalizedString("Email already in use.", comment: "")
                case .dynamicLinkNotActivated:
                    return NSLocalizedString("Dynamic link not activated", comment: "")
                case .emailChangeNeedsVerification:
                    return NSLocalizedString("Email change needs verification", comment: "")
                case .expiredActionCode:
                    return NSLocalizedString("Expired Action Code.", comment: "")
                case .gameKitNotLinked:
                    return NSLocalizedString("Game Kit Not Linked.", comment: "")
                case .internalError:
                    return NSLocalizedString("Internal Error. Try Again.", comment: "")
                case .invalidAPIKey:
                    return NSLocalizedString("Invalid API Key", comment: "")
                case .wrongPassword:
                    return NSLocalizedString("Wrong Password. Try Again.", comment: "")
                case .weakPassword:
                    return NSLocalizedString("Password too weak, must be at least 6 characters.", comment: "")
                case .userNotFound:
                    return NSLocalizedString("User Not Found", comment: "")
                case .userMismatch:
                    return NSLocalizedString("Usermismatch", comment: "")
                case .unverifiedEmail:
                    return NSLocalizedString("Unverified Email", comment: "")
                case .missingEmail:
                    return NSLocalizedString("Missing Email", comment: "")
                default:
                    return NSLocalizedString("Something went wrong, try again!", comment: "")
                }
            }
        }
   
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
}
