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
    var filteredProductList = BehaviorSubject<[Products]>(value: []) // Filtrelenmiş ürünlerin listesi
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
    
    // Favorilere ürün ekle
    func addToFavorites(product: Products, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.addProductToFavorites(product: product) { result in
            completion(result)
            
        }
    }
    
    
    
    
    
    
    // Arama sorgusuna göre manuel filtreleme yap
    func search(query: String, completion: @escaping ([Products]) -> Void) {
        productList
            .subscribe(onNext: { products in
                if query.isEmpty {
                    completion(products) // Sorgu boşsa tüm ürünleri döndür
                } else {
                    let filteredProducts = products.filter {
                        $0.ad?.lowercased().contains(query.lowercased()) ?? false
                    }
                    completion(filteredProducts) // Filtrelenmiş ürünleri döndür
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    
    
    
    // Ürünleri düşükten yükseğe sıralama
    func sortProductsAscending(completion: @escaping ([Products]) -> Void) {
        productList
            .map { $0.sorted { ($0.fiyat ?? 0) < ($1.fiyat ?? 0) } } // Fiyata göre sıralama
            .subscribe(onNext: { sortedProducts in
                completion(sortedProducts) // Sıralanmış ürünleri döndür
            })
            .disposed(by: disposeBag)
    }
    
    // Ürünleri yüksekten düşüğe sıralama
    func sortProductsDescending(completion: @escaping ([Products]) -> Void) {
        productList
            .map { $0.sorted { ($0.fiyat ?? 0) > ($1.fiyat ?? 0) } } // Fiyata göre ters sıralama
            .subscribe(onNext: { sortedProducts in
                completion(sortedProducts) // Sıralanmış ürünleri döndür
            })
            .disposed(by: disposeBag)
    }
    
    
    
    
    
    
    
    // Belirli bir kategoriye göre ürünleri filtrele
    func filterProducts(by category: String, completion: @escaping ([Products]) -> Void) {
        productList
            .subscribe(onNext: { products in
                let filteredProducts = products.filter { $0.kategori == category }
                completion(filteredProducts) // Filtrelenmiş ürünleri döndür
            })
            .disposed(by: disposeBag)
    }
}
