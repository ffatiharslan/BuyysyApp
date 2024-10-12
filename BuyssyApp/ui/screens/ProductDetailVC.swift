//
//  ProductDetailVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import UIKit

class ProductDetailVC: UIViewController {

    var product: Products?
    
    var viewModel = ProductDetailViewModel()
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    @IBOutlet weak var adetStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product {
            if let imageURL = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(product.resim!)") {
               productImageView.kf.setImage(with: imageURL)
            }
            productNameLabel.text = product.ad
        }
    }
    
    
    @IBAction func adetStepper(_ sender: UIStepper) {
        adetLabel.text = "\(Int(sender.value))"
    }
    
    
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        if let product = product {
            viewModel.addToCart(ad: product.ad!,
                                resim: product.resim!,
                                kategori: product.kategori!,
                                fiyat: product.fiyat!,
                                marka: product.marka!,
                                siparisAdeti: Int(adetStepper.value),
                                kullaniciAdi: "FatihArslan")
        }
    }
    
}

