//
//  AuthenticationManager.swift
//  BuyssyApp
//
//  Created by fatih arslan on 14.10.2024.
//

import Foundation
import FirebaseAuth

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
}
