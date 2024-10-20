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
    
    var stepperValue: Int = 1 {
        didSet {
            adetLabel.text = "\(stepperValue)"
        }
    }
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    @IBOutlet weak var stepperStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product {
            setupProductDetails(product)
        }
        
        stepperStackView.layer.borderWidth = 0.2
        stepperStackView.layer.borderColor = UIColor.systemGray5.cgColor
        stepperStackView.layer.cornerRadius = 10
        
        adetLabel.layer.masksToBounds = true
        adetLabel.layer.cornerRadius = 10
        
    }
    
    private func setupProductDetails(_ product: Products) {
        if let imageURL = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(product.resim!)") {
            productImageView.kf.setImage(with: imageURL)
        }
        productNameLabel.text = "\(product.marka!) \(product.ad!)"
        priceLabel.text = "\(product.fiyat!) ₺"
    }
    
    
    @IBAction func decrementButtonTapped(_ sender: UIButton) {
        if stepperValue > 1 {
            stepperValue -= 1
        }
    }
    
   
    @IBAction func incrementButtonTapped(_ sender: Any) {
        if stepperValue < 10 {
            stepperValue += 1
        }
    }
    
    
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        
        guard let product = product else { return }
        
        viewModel.addToCart(ad: product.ad!,
                            resim: product.resim!,
                            kategori: product.kategori!,
                            fiyat: product.fiyat!,
                            marka: product.marka!,
                            siparisAdeti: stepperValue,
                            kullaniciAdi: "FatihArslan") { result in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                print("Sepete eklenemedi: \(error.localizedDescription)")
            }
        }
    }
}

