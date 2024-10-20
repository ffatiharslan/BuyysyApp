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
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.signInWithGoogle(presentingVC: presentingVC, completion: completion)
    }
    
    
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.signInWithEmail(email: email, password: password, completion: completion)
    }
    
    
    func isLoggedIn() -> Bool {
        return authService.checkIfLoggedIn()
    }
}


