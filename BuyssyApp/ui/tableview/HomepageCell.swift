//
//  HomepageCell.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import UIKit

protocol HomepageCellProtocol {
    func addToFavorites(indexpath: IndexPath)
}

class HomepageCell: UICollectionViewCell {
    
    var homepageCellProtocol: HomepageCellProtocol?
    var indexPath: IndexPath?
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func addToFavoritesButtonTapped(_ sender: Any) {
        addToFavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        homepageCellProtocol?.addToFavorites(indexpath: indexPath!)
    }
}
