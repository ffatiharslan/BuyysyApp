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
    
    var filteredProductList = [Products]() // Filtrelenmiş ürünlerin listesi
    
    var viewModel = HomepageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            case .success(let products):
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
}


extension HomepageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Arama sorgusunu ViewModel'e gönder ve sonuçları al
        viewModel.search(query: searchText) { [weak self] filteredProducts in
            self?.productList = filteredProducts
            self?.productsCollectionView.reloadData() // Sonuçları güncelle
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
        
        cell.productNameLabel.text = product.ad
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        
        cell.homepageCellProtocol = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = productList[indexPath.row]
        print(product.ad!, product.resim!, product.fiyat!, product.kategori!, product.marka!, product.id!)
        performSegue(withIdentifier: "toDetail", sender: product)
    }
    
    
    func addToFavorites(indexpath: IndexPath) {
        let product = productList[indexpath.row]
        viewModel.addToFavorites(product: product) { result in
            switch result {
            case .success:
                print("Ürün favorilere eklendi.")
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

