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
    // Firebase'de email ve şifreyle kayıt olma
    func register(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    // Firebase'de email ve şifreyle giriş yapma
    func login(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    // Oturum açık mı kontrol etme
    func checkIfLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    // Oturumu kapatma
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    
    
    
    
    
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Client ID bulunamadı."])))
                return
            }

            let config = GIDConfiguration(clientID: clientID)

            // Google Sign-In işlemini başlatıyoruz
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
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

                // Firebase Authentication ile oturum açma
                Auth.auth().signIn(with: credential) { _, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    
}
