//
//  RegisterViewModel.swift
//  BuyssyApp
//
//  Created by fatih arslan on 14.10.2024.
//

import Foundation
import FirebaseAuth

class RegisterViewModel {

    private let authService = AuthenticationManager()

    // Kayıt işlemi ve şifre kontrolü
    func register(email: String, password: String, confirmPassword: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        
        // Şifre doğrulama kontrolü
        guard password == confirmPassword else {
            let error = NSError(domain: "RegisterError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Şifreler uyuşmuyor"])
            completion(.failure(error))
            return
        }
        
        // Firebase kayıt işlemi
        authService.register(email: email, password: password) { result in
            completion(result)
        }
    }
}
