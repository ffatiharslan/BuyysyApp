//
//  FavoritesCell.swift
//  BuyssyApp
//
//  Created by fatih arslan on 15.10.2024.
//

import UIKit

protocol FavoritesCellProtocol {
    func deleteFromFavorites(indexPath: IndexPath)
    func addToCart(indexPath: IndexPath)
}


class FavoritesCell: UITableViewCell {
    
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var favoritesCellProtocol: FavoritesCellProtocol?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        favoritesCellProtocol?.deleteFromFavorites(indexPath: indexPath)
    }
    
    
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        favoritesCellProtocol?.addToCart(indexPath: indexPath)
    }
}
