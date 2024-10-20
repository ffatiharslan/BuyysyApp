//
//  ProductsByCategoryVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 16.10.2024.
//

import UIKit
import RxSwift

class ProductsByCategoryVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedCategory: String? // Seçilen kategori
    private let viewModel = HomepageViewModel()
    private let disposeBag = DisposeBag()
    private var products = [Products]() // Ürünler listesi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewLayout()
        fetchProductsByCategory()
    }
    
    // Seçilen kategoriye göre ürünleri getir
    private func fetchProductsByCategory() {
        guard let category = selectedCategory else { return }
        viewModel.filterProducts(by: category) { [weak self] filteredProducts in
            self?.products = filteredProducts
            self?.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 30) / 2
        layout.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.7)
        
        collectionView.collectionViewLayout = layout
    }
}

extension ProductsByCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsByCategoryCell", for: indexPath) as! ProductsByCategoryCell
        let product = products[indexPath.row]
        
        
        if let imageURL = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(product.resim!)") {
            cell.productImageView.kf.setImage(with: imageURL)
        }
        
        
        cell.priceLabel.text = "\(product.fiyat!) ₺"
        cell.productNameLabel.text = product.ad
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        
        return cell
    }
}
