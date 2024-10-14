//
//  LoginViewModel.swift
//  BuyssyApp
//
//  Created by fatih arslan on 14.10.2024.
//

import Foundation
import UIKit

class LoginViewModel {
    
    
    private let authService = AuthenticationManager()
    
    // Kullanıcı email ve şifreyle giriş yapıyor
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.login(email: email, password: password) { result in
            switch result {
            case .success:
                print("Giriş başarılı.")
                completion(.success(()))
            case .failure(let error):
                print("Giriş hatası: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    
    // Google Sign-In işlemini başlatır
        func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
            authService.signInWithGoogle(presentingVC: presentingVC, completion: completion)
        }
    
    
    // Oturum açık mı kontrol et
    func isLoggedIn() -> Bool {
        return authService.checkIfLoggedIn()
    }
}


