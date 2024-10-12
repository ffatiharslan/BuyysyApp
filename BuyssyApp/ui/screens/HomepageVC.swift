//
//  ViewController.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import UIKit
import Kingfisher

class HomepageVC: UIViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var productList = [Products]()
    
    var viewModel = HomepageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 30) / 2
        
        layout.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.7)
        
        productsCollectionView.collectionViewLayout = layout
        
        
        _ = viewModel.productList.subscribe(onNext: {list in
            self.productList = list

            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchProducts()
    }
}



extension HomepageVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
}
