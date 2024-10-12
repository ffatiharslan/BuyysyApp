//
//  Products.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import Foundation

class Products: Codable {
    var id: Int?
    var ad: String?
    var resim: String?
    var kategori: String?
    var fiyat: Int?
    var marka: String?
    
    init(id: Int, ad: String, resim: String, kategori: String, fiyat: Int, marka: String) {
        self.id = id
        self.ad = ad
        self.resim = resim
        self.kategori = kategori
        self.fiyat = fiyat
        self.marka = marka
    }
}
