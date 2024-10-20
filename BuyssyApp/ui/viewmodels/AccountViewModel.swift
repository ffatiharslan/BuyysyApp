//
//  AccountViewModel.swift
//  BuyssyApp
//
//  Created by fatih arslan on 15.10.2024.
//

import Foundation
import FirebaseAuth

class AccountViewModel {
    private let authManager = AuthenticationManager()
    let options = ["Favorilerim", "Sepetimdeki Ürünler", "Teslimat Adreslerim"]
    var userEmail: String = ""
    
    init() {
        fetchUserEmail()
    }
    
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        authManager.signOut(completion: completion)
    }
    
    func fetchUserEmail() {
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email ?? "Email bulunamadı"
        } else {
            userEmail = "Kullanıcı bulunamadı"
        }
    }
}
