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
        fetchProducts { _ in }
    }
    
    func fetchProducts(completion: @escaping (Result<[Products], Error>) -> Void) {
        networkManager.fetchProducts { result in
            switch result {
            case .success(let products):
                self.productList.onNext(products)
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
