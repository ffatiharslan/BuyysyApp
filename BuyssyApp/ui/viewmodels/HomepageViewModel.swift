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
    var firestoreManager = FirestoreManager()
    
    var productList = BehaviorSubject<[Products]>(value: [Products]())
    var filteredProductList = BehaviorSubject<[Products]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    
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
    
    
    func addToFavorites(product: Products, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.addProductToFavorites(product: product) { result in
            completion(result)
            
        }
    }
    
    
    func removeProductFromFavorites(productID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.removeProductFromFavorites(productID: productID, completion: completion)
    }
    
    func isProductFavorited(productID: Int, completion: @escaping (Bool) -> Void) {
        firestoreManager.isProductFavorited(productID: productID, completion: completion)
    }
    
    
    func search(query: String, completion: @escaping ([Products]) -> Void) {
        productList.subscribe(onNext: { products in
                if query.isEmpty {
                    completion(products)
                } else {
                    let filteredProducts = products.filter {
                        $0.ad?.lowercased().contains(query.lowercased()) ?? false
                    }
                    completion(filteredProducts)
                }
            })
            .disposed(by: disposeBag)
    }
    

    func sortProductsAscending(completion: @escaping ([Products]) -> Void) {
        productList
            .map { $0.sorted { ($0.fiyat ?? 0) < ($1.fiyat ?? 0) } }
            .subscribe(onNext: { sortedProducts in
                completion(sortedProducts)
            })
            .disposed(by: disposeBag)
    }
    
    
    func sortProductsDescending(completion: @escaping ([Products]) -> Void) {
        productList
            .map { $0.sorted { ($0.fiyat ?? 0) > ($1.fiyat ?? 0) } }
            .subscribe(onNext: { sortedProducts in
                completion(sortedProducts)
            })
            .disposed(by: disposeBag)
    }
    
    
    
    func filterProducts(by category: String, completion: @escaping ([Products]) -> Void) {
        productList
            .subscribe(onNext: { products in
                let filteredProducts = products.filter { $0.kategori == category }
                completion(filteredProducts) 
            })
            .disposed(by: disposeBag)
    }
}
