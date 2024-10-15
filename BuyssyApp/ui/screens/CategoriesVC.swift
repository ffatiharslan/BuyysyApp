//
//  CategoriesVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 16.10.2024.
//

import UIKit
import RxSwift

class CategoriesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    private let viewModel = HomepageViewModel()
    private let disposeBag = DisposeBag()
    private var categories = [String]() // Kategoriler listesi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // Ürünleri çek ve kategorileri türet
        viewModel.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.categories = Array(Set(products.compactMap { $0.kategori })) // Kategorileri türet
                self?.tableView.reloadData()
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CategoriesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        let productsVC = storyboard?.instantiateViewController(withIdentifier: "ProductsByCategoryVC") as! ProductsByCategoryVC
        productsVC.selectedCategory = selectedCategory
        navigationController?.pushViewController(productsVC, animated: true)
    }
}
