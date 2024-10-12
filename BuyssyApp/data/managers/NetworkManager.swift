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
    
    func fetchProducts() {
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        
        AF.request(url, method: .get).response{ response in
            if let data  = response.data {
                do{
                    let cevap = try JSONDecoder().decode(ProductsResponse.self, from: data)
                    if let list = cevap.urunler {
                        self.productList.onNext(list) //Tetikleme
                    }
                }
                catch {
                    print(error.localizedDescription)
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
                   kullaniciAdi: String) {
        
        let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
        let parameters: Parameters = [
            "ad": ad,
            "resim": resim,
            "kategori": kategori,
            "fiyat": fiyat,
            "marka": marka,
            "siparisAdeti": siparisAdeti,
            "kullaniciAdi": kullaniciAdi
        ]
        
        AF.request(url, method: .post, parameters: parameters).response{ response in
            if let data  = response.data {
                do{
                    let response = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    print("Başarı: \(response.success!)")
                    print("Mesaj: \(response.message!)")
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func fetchCartProducts(kullaniciAdi: String) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        
        let parameters: Parameters = ["kullaniciAdi": kullaniciAdi]
        
        AF.request(url, method: .post, parameters: parameters).response{ response in
            if let data  = response.data {
                do{
                    let response = try JSONDecoder().decode(CartProductsResponse.self, from: data)
                    if let list = response.urunler_sepeti {
                        self.cartProductList.onNext(list) //Tetikleme
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
}
