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
}
