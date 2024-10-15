//
//  FavoritesVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 15.10.2024.
//

import UIKit

class FavoritesVC: UIViewController {
    
    private let viewModel = FavoritesViewModel()
    
    var favoriteProductList = [Products]()
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        _ = viewModel.favoriteProductList.subscribe(onNext: { list in
            self.favoriteProductList = list
            DispatchQueue.main.async {
                self.favoritesTableView.reloadData()
            }
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites { result in
            switch result {
            case .success(let products):
                print("Favori ürünler başarıyla yüklendi")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Favori ürünleri getir
    private func fetchFavoriteProducts() {
        viewModel.fetchFavorites { [weak self] result in
            switch result {
            case .success(_):
                self?.favoritesTableView.reloadData()
            case .failure(let error):
                self?.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    // Hata mesajı göstermek için alert
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}




extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        let product = favoriteProductList[indexPath.row]
        cell.nameLabel.text = product.ad
        cell.brandLabel.text = product.marka
        cell.categoryLabel.text = product.kategori
        cell.priceLabel.text = "\(product.fiyat!)"
        cell.productImageView.image = UIImage(systemName: "person")
        return cell
    }
    
    
    // Ürün favorilerden çıkarma
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = favoriteProductList[indexPath.row]
        viewModel.removeProductFromFavorites(productID: product.id!) { result in
            switch result {
            case .success():
                print("Ürün favorilerden başarıyla silindi.")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
