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
        fetchCartProducts { _ in }
    }
    
    func fetchCartProducts(completion: @escaping (Result<[CartProducts], Error>) -> Void) {
        networkManager.fetchCartProducts(kullaniciAdi: kullaniciAdi) { result in
            switch result {
            case .success(let products):
                self.cartProductList.onNext(products)
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteFromCart(sepetId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        networkManager.deleteFromCart(sepetId: sepetId, kullaniciAdi: kullaniciAdi) { [self] result in
            switch result {
            case .success(let message):
                self.fetchCartProducts { _ in }
                
                var currentList = try! cartProductList.value()
                if let index = currentList.firstIndex(where: { $0.sepetId == sepetId }) {
                    currentList.remove(at: index)
                }
                cartProductList.onNext(currentList)
                
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
