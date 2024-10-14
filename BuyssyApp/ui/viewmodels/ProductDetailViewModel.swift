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

        // Sepetteki ürünleri kontrol et.
        networkManager.fetchCartProducts(kullaniciAdi: kullaniciAdi) { result in
            switch result {
            case .success(let cartProducts):
                // Sepet boşsa, doğrudan ekle.
                if cartProducts.isEmpty {
                    print("Sepet boş, ürün ekleniyor...")
                    self.performAddToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat,
                                          marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi,
                                          completion: completion)
                    return
                }

                // Sepette aynı ürün var mı kontrol et.
                if let existingProduct = cartProducts.first(where: { $0.ad == ad }) {
                    let newQuantity = existingProduct.siparisAdeti! + siparisAdeti
                    print("Aynı ürün bulundu, adet güncelleniyor...")
                    
                    // Mevcut ürünü silip yeni adetle ekle.
                    self.networkManager.deleteFromCart(sepetId: existingProduct.sepetId!, kullaniciAdi: kullaniciAdi) { deleteResult in
                        switch deleteResult {
                        case .success:
                            print("Eski ürün silindi, yeni ürün ekleniyor...")
                            self.performAddToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat,
                                                  marka: marka, siparisAdeti: newQuantity, kullaniciAdi: kullaniciAdi,
                                                  completion: completion)
                        case .failure(let error):
                            print("Silme işlemi başarısız: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                } else {
                    // Sepette farklı bir ürün varsa, yeni ürünü doğrudan ekle.
                    print("Sepette farklı ürün var, yeni ürün ekleniyor...")
                    self.performAddToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat,
                                          marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi,
                                          completion: completion)
                }

            case .failure(let error):
                // Sepet ürünleri alınamadığında doğrudan ekleme yap.
                print("Sepet alınamadı, doğrudan ürün ekleniyor...")
                self.performAddToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat,
                                      marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi,
                                      completion: completion)
            }
        }
    }

    // Ürün ekleme işlemi burada yapılır.
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
                print("Ürün başarıyla sepete eklendi: \(message)")
                completion(.success(message))
            case .failure(let error):
                print("Ekleme işlemi başarısız: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }





}

