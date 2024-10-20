//
//  CategoriesVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 16.10.2024.
//

import UIKit
import RxSwift
import Kingfisher

class CategoriesVC: UIViewController {
    
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    private let viewModel = HomepageViewModel()
    private let disposeBag = DisposeBag()
    private var categories = [String]() // Kategoriler listesi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Kategoriler"
        
        
        setupCollectionView()
        
        viewModel.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.categories = Array(Set(products.compactMap { $0.kategori })) // Kategorileri türet
                self?.categoriesCollectionView.reloadData()
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupCollectionView() {
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let itemWidth = (view.frame.width - 3 * spacing) / 2 // 2 sütunlu layout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        categoriesCollectionView.collectionViewLayout = layout
    }
}

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.row]
        
        cell.categoryNameLabel.text = category
        
        switch category {
        case "Aksesuar":
            cell.categoryImageView.image = UIImage(named: "saat")
            
        case "Kozmetik":
            cell.categoryImageView.image = UIImage(named: "ruj")
            
        case "Teknoloji":
            cell.categoryImageView.image = UIImage(named: "bilgisayar")
        default:
            print("Kategori bulunamadı.")
        }
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        let productsVC = storyboard?.instantiateViewController(withIdentifier: "ProductsByCategoryVC") as! ProductsByCategoryVC
        productsVC.selectedCategory = selectedCategory
        navigationController?.pushViewController(productsVC, animated: true)
    }
}
