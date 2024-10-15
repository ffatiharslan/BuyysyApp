//
//  AccountViewModel.swift
//  BuyssyApp
//
//  Created by fatih arslan on 15.10.2024.
//

import Foundation

class AccountViewModel {
    private let authManager = AuthenticationManager()
    
    // Çıkış işlemini başlatır
        func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
            authManager.signOut(completion: completion)
        }
}
