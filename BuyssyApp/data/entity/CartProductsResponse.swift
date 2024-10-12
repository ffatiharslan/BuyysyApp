//
//  CartProductsResponse.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import Foundation

class CartProductsResponse: Codable {
    var urunler_sepeti: [CartProducts]?
    var success: Int?
}
