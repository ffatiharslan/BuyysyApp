//
//  FavoritesViewModel.swift
//  BuyssyApp
//
//  Created by fatih arslan on 15.10.2024.
//

import Foundation
import RxSwift
import Alamofire

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
    
    func addToCart(ad: String,
                   resim: String,
                   kategori: String,
                   fiyat: Int,
                   marka: String,
                   siparisAdeti: Int,
                   kullaniciAdi: String,
                   completion: @escaping (Result<String, Error>) -> Void) {
        
        let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
        let parameters: Parameters = [
            "ad": ad, "resim": resim, "kategori": kategori, "fiyat": fiyat,
            "marka": marka, "siparisAdeti": siparisAdeti, "kullaniciAdi": kullaniciAdi
        ]
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            if let data = response.data {
                do {
                    let decodedResponse = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    completion(.success(decodedResponse.message ?? "Başarılı"))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}

