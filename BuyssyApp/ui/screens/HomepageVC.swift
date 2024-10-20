//
//  ViewController.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import UIKit
import Kingfisher

class HomepageVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var productList = [Products]()
    
    var filteredProductList = [Products]()
    
    var viewModel = HomepageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        self.navigationItem.title = "Buyysy"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: UIFont(name: "ADLaMDisplay-Regular", size: 22)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        searchBar.delegate = self
        
        setupCollectionViewLayout()
        
        _ = viewModel.productList.subscribe(onNext: { list in
            self.productList = list
            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProducts { result in
            switch result {
            case .success(_):
                print("Ürünler başarıyla yüklendi.")
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail",
           let product = sender as? Products,
           let destinationVC = segue.destination as? ProductDetailVC {
            destinationVC.product = product
        }
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 30) / 2
        layout.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.7)
        
        productsCollectionView.collectionViewLayout = layout
    }
    
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Sıralama Seç", message: "Ürünleri nasıl sıralamak istersiniz?", preferredStyle: .actionSheet)
        
        
        let defaultSortAction = UIAlertAction(title: "Varsayılan Sıralama", style: .default) { _ in
            self.viewModel.fetchProducts { result in
                switch result {
                case .success(let products):
                    self.productList = products
                    self.productsCollectionView.reloadData()
                case .failure(let error):
                    print("Hata: \(error.localizedDescription)")
                }
            }
        }
        
        
        let sortHighToLowAction = UIAlertAction(title: "Fiyata Göre (Önce En Yüksek)", style: .default) { _ in
            self.viewModel.sortProductsDescending { sortedProducts in
                self.productList = sortedProducts
                self.productsCollectionView.reloadData()
            }
        }
        
        
        let sortLowToHighAction = UIAlertAction(title: "Fiyata Göre (Önce En Düşük)", style: .default) { _ in
            self.viewModel.sortProductsAscending { sortedProducts in
                self.productList = sortedProducts
                self.productsCollectionView.reloadData()
            }
        }
        
    
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alert.addAction(defaultSortAction)
        alert.addAction(sortHighToLowAction)
        alert.addAction(sortLowToHighAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}



extension HomepageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText) { filteredProducts in
            self.productList = filteredProducts
            self.productsCollectionView.reloadData()
        }
    }
}


extension HomepageVC: UICollectionViewDelegate, UICollectionViewDataSource, HomepageCellProtocol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomepageCell", for: indexPath) as! HomepageCell
        let product = productList[indexPath.row]
        
        if let imageURL = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(product.resim!)") {
            cell.productImageView.kf.setImage(with: imageURL)
        }
        
        cell.priceLabel.text = "\(product.fiyat!) ₺"
        cell.productNameLabel.text = product.ad
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        
        cell.homepageCellProtocol = self
        cell.indexPath = indexPath
        
        cell.addToFavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        viewModel.isProductFavorited(productID: product.id ?? 0) { isFavorited in
            let imageName = isFavorited ? "heart.fill" : "heart"
            cell.addToFavoritesButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = productList[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: product)
    }
    
    
    func addToFavorites(indexpath: IndexPath) {
        let product = productList[indexpath.row]
        
        viewModel.isProductFavorited(productID: product.id ?? 0) { isFavorited in
            if isFavorited {
                self.viewModel.removeProductFromFavorites(productID: product.id ?? 0) { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.productsCollectionView.reloadItems(at: [indexpath])
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            } else {
                self.viewModel.addToFavorites(product: product) { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.productsCollectionView.reloadItems(at: [indexpath]) 
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

