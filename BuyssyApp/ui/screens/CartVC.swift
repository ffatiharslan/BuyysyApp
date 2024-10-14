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
        
        cell.brandLabel.text = cartProduct.ad
        cell.adetLabel.text = "\(cartProduct.siparisAdeti!)"
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
        
        
        return cell
    }
    
    func deleteButtonTapped(indexPath: IndexPath) {
        // İlgili işlemleri burada gerçekleştirebilirsiniz.
    }
}


