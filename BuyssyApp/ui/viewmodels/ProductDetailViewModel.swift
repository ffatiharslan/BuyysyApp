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
                   kullaniciAdi: String) {
        networkManager.addToCart(ad: ad,
                                 resim: resim,
                                 kategori: kategori,
                                 fiyat: fiyat,
                                 marka: marka,
                                 siparisAdeti: siparisAdeti,
                                 kullaniciAdi: kullaniciAdi)
    }
}
