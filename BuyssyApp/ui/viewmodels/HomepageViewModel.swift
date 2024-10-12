//
//  HomepageViewModel.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import Foundation
import RxSwift

class HomepageViewModel {
    
    var networkManager = NetworkManager()
    var productList = BehaviorSubject<[Products]>(value: [Products]())
    
    init() {
        fetchProducts()
        productList = networkManager.productList
    }
    
    func fetchProducts() {
        networkManager.fetchProducts()
    }
}
