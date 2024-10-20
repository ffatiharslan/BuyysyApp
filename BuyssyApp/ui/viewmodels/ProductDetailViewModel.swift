//
//  ProductDetailViewModel.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import Foundation

class ProductDetailViewModel {
    
    var networkManager = NetworkManager()
    
    func addToCart(ad: String,
                   resim: String,
                   kategori: String,
                   fiyat: Int,
                   marka: String,
                   siparisAdeti: Int,
                   kullaniciAdi: String,
                   completion: @escaping (Result<String, Error>) -> Void) {

        
        networkManager.fetchCartProducts(kullaniciAdi: kullaniciAdi) { result in
            switch result {
            case .success(let cartProducts):
                if cartProducts.isEmpty {
                    self.performAddToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat,
                                          marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi,
                                          completion: completion)
                    return
                }

                if let existingProduct = cartProducts.first(where: { $0.ad == ad }) {
                    let newQuantity = existingProduct.siparisAdeti! + siparisAdeti
                    
                    self.networkManager.deleteFromCart(sepetId: existingProduct.sepetId!, kullaniciAdi: kullaniciAdi) { deleteResult in
                        switch deleteResult {
                        case .success:
                            self.performAddToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat,
                                                  marka: marka, siparisAdeti: newQuantity, kullaniciAdi: kullaniciAdi,
                                                  completion: completion)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    self.performAddToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat,
                                          marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi,
                                          completion: completion)
                }

            case .failure(let error):
                self.performAddToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat,
                                      marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi,
                                      completion: completion)
            }
        }
    }


    private func performAddToCart(ad: String,
                                  resim: String,
                                  kategori: String,
                                  fiyat: Int,
                                  marka: String,
                                  siparisAdeti: Int,
                                  kullaniciAdi: String,
                                  completion: @escaping (Result<String, Error>) -> Void) {

        networkManager.addToCart(ad: ad,
                                 resim: resim,
                                 kategori: kategori,
                                 fiyat: fiyat,
                                 marka: marka,
                                 siparisAdeti: siparisAdeti,
                                 kullaniciAdi: kullaniciAdi) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

