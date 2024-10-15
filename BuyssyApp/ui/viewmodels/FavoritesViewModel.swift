//
//  FavoritesViewModel.swift
//  BuyssyApp
//
//  Created by fatih arslan on 15.10.2024.
//

import Foundation
import RxSwift

class FavoritesViewModel {

    private let firestoreManager = FirestoreManager()
    

    var favoriteProductList = BehaviorSubject<[Products]>(value: [Products]())
    
    init() {
        fetchFavorites { _ in
            
        }
    }
    
    func fetchFavorites(completion: @escaping (Result<[Products], Error>) -> Void) {
        firestoreManager.fetchFavoriteProducts { result in
            switch result {
            case .success(let products):
                self.favoriteProductList.onNext(products)
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func removeProductFromFavorites(productID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.removeProductFromFavorites(productID: productID, completion: completion)
        firestoreManager.fetchFavoriteProducts { result in
            switch result {
            case .success(let products):
                print("Favori ürünler yüklendi")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

