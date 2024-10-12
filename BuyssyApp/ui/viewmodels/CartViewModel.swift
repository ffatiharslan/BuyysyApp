//
//  CartViewModel.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import Foundation
import RxSwift

class CartViewModel {
    
    var networkManager = NetworkManager()
    var cartProductList = BehaviorSubject<[CartProducts]>(value: [CartProducts]())
    
    var kullaniciAdi = "FatihArslan"
    
    init() {
        fetchCartProducts(kullaniciAdi: kullaniciAdi)
        cartProductList = networkManager.cartProductList
    }
    
    func fetchCartProducts(kullaniciAdi: String) {
        networkManager.fetchCartProducts(kullaniciAdi: kullaniciAdi)
    }
}
