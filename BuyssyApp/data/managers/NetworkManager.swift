//
//  NetworkManager.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    
    var productList = BehaviorSubject<[Products]>(value: [Products]())
    var cartProductList = BehaviorSubject<[CartProducts]>(value: [CartProducts]())
    
    func fetchProducts(completion: @escaping (Result<[Products], Error>) -> Void) {
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do {
                    let decodedResponse = try JSONDecoder().decode(ProductsResponse.self, from: data)
                    if let list = decodedResponse.urunler {
                        self.productList.onNext(list)
                        completion(.success(list))
                    }
                } catch {
                    completion(.failure(error))
                }
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
    
    
    func fetchCartProducts(kullaniciAdi: String, completion: @escaping (Result<[CartProducts], Error>) -> Void) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        let parameters: Parameters = ["kullaniciAdi": kullaniciAdi]
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            if let data = response.data {
                do {
                    let decodedResponse = try JSONDecoder().decode(CartProductsResponse.self, from: data)
                    if let list = decodedResponse.urunler_sepeti {
                        self.cartProductList.onNext(list)
                        completion(.success(list))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    func deleteFromCart(sepetId: Int, kullaniciAdi: String,
                        completion: @escaping (Result<String, Error>) -> Void) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
        let parameters: Parameters = ["sepetId": sepetId, "kullaniciAdi": kullaniciAdi]
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            if let data = response.data {
                do {
                    let decodedResponse = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    completion(.success(decodedResponse.message ?? "Silme işlemi başarılı"))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
