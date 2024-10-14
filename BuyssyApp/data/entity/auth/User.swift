//
//  User.swift
//  BuyssyApp
//
//  Created by fatih arslan on 14.10.2024.
//

import Foundation
import FirebaseAuth

class User {
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    
    // Firebase'den User nesnesi oluşturma
    init(from firebaseUser: FirebaseAuth.User) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email
        self.displayName = firebaseUser.displayName
        self.photoURL = firebaseUser.photoURL
    }
}
