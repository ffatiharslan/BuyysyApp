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
    
    
    var cartProductList = [CartProducts]()
    
    var viewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartProductsTableView.delegate = self
        cartProductsTableView.dataSource = self
        
        _ = viewModel.cartProductList.subscribe(onNext: { list in
            self.cartProductList = list
            
            DispatchQueue.main.async {
                self.cartProductsTableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchCartProducts(kullaniciAdi: viewModel.kullaniciAdi)
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        let cartProduct = cartProductList[indexPath.row]
        
        if let imageURL = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(cartProduct.resim!)") {
            cell.productImageView.kf.setImage(with: imageURL)
        }
        
        cell.brandLabel.text = cartProduct.ad
        cell.adetLabel.text = "\(cartProduct.siparisAdeti!)"
        
        return cell
    }
}
