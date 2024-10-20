//
//  AuthenticationManager.swift
//  BuyssyApp
//
//  Created by fatih arslan on 14.10.2024.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseCore
import GoogleSignIn

class AuthenticationManager {
    
    
    func register(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    
    func checkIfLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Client ID bulunamadı."])))
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "GoogleAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authentication bilgisi alınamadı."])))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            if let currentUser = Auth.auth().currentUser {
                currentUser.link(with: credential) { authResult, error in
                    if let error = error {
                        if (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
                            let linkedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? AuthCredential
                            self?.signInWithCredential(linkedCredential, completion: completion)
                        } else {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.success(()))
                    }
                }
            } else {
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }

    
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                if (error as NSError).code == AuthErrorCode.accountExistsWithDifferentCredential.rawValue {
                    self?.handleAccountLinking(email: email, completion: completion)
                } else {
                    completion(.failure(error))
                }
            } else {
                completion(.success(()))
            }
        }
    }

    private func signInWithCredential(_ credential: AuthCredential?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let credential = credential else {
            completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Credential bulunamadı."])))
            return
        }

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }


   private func handleAccountLinking(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { methods, error in
            if let methods = methods, methods.contains("google.com") {
                completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google ile giriş yapmanız gerekiyor."])))
            } else {
                completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bu email başka bir yöntemle kayıtlı."])))
            }
        }
    }

    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
}
