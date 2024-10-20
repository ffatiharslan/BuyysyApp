//
//  CartVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import UIKit
import RxSwift
import Kingfisher

class CartVC: UIViewController {
    
    
    @IBOutlet weak var cartProductsTableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    var cartProductList = [CartProducts]()
    var viewModel = CartViewModel()
    var cartViewModel = ProductDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartProductsTableView.delegate = self
        cartProductsTableView.dataSource = self
        
        setupViewBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchCartProducts { result in
            switch result {
            case .success:
                print("Sepet başarıyla yüklendi.")
            case .failure(let error):
                print("Sepet yüklenirken hata: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func setupViewBindings() {
        _ = viewModel.cartProductList.subscribe(onNext: { list in
            self.cartProductList = list
            self.updateUI()
        })
    }
    
    private func updateUI() {
        let isEmpty = cartProductList.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        cartProductsTableView.isHidden = isEmpty
        DispatchQueue.main.async {
            self.cartProductsTableView.reloadData()
        }
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource, CellProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let cartProduct = cartProductList[indexPath.row]
        
        if let imageURL = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(cartProduct.resim!)") {
            cell.productImageView.kf.setImage(with: imageURL)
        }
        
        cell.brandLabel.text = "\(cartProduct.marka!) \(cartProduct.ad!)"
        cell.priceLabel.text = "\(cartProduct.fiyat!)"
        cell.adetLabel.text = "\(cartProduct.siparisAdeti!)"
        cell.totalPriceLabel.text = "\(cartProduct.fiyat! * cartProduct.siparisAdeti!)"
        cell.cellProtocol = self
        cell.indexPath = indexPath
        
        cell.onRemoveButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteFromCart(sepetId: cartProduct.sepetId!) { result in
                switch result {
                case .success(let message):
                    print(message)
                    self.viewModel.fetchCartProducts { fetchResult in
                        switch fetchResult {
                        case .success:
                            print("Sepet başarıyla güncellendi.")
                        case .failure(let error):
                            print("Sepet güncellenirken hata: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Hata: \(error.localizedDescription)")
                }
            }
        }
        
        cell.stepperStackView.layer.borderWidth = 0.2
        cell.stepperStackView.layer.borderColor = UIColor.black.cgColor
        cell.stepperStackView.layer.cornerRadius = 10
        
        cell.adetLabel.layer.masksToBounds = true
        cell.adetLabel.layer.cornerRadius = 10
        
        return cell
    }
    
    func deleteButtonTapped(indexPath: IndexPath) {
        // İlgili işlemleri burada gerçekleştirebilirsiniz.
    }
    
    
    func decrementCartProduct(indexPath: IndexPath) {
        let product = cartProductList[indexPath.row]
        if product.siparisAdeti! > 1 {
            cartViewModel.addToCart(ad: product.ad!, resim: product.resim!, kategori: product.kategori!, fiyat: product.fiyat!, marka: product.marka!, siparisAdeti: -1, kullaniciAdi: "FatihArslan") { result in
                switch result {
                case .success(_):
                    self.viewModel.fetchCartProducts { result in
                        switch result {
                        case .success(_):
                            print("Sepette ürün artırıldı")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func incrementCartProduct(indexPath: IndexPath) {
        let product = cartProductList[indexPath.row]
        if product.siparisAdeti! < 10 {
            cartViewModel.addToCart(ad: product.ad!, resim: product.resim!, kategori: product.kategori!, fiyat: product.fiyat!, marka: product.marka!, siparisAdeti: 1, kullaniciAdi: "FatihArslan") { result in
                switch result {
                case .success(_):
                    self.viewModel.fetchCartProducts { result in
                        switch result {
                        case .success(_):
                            print("Sepette ürün artırıldı")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}


