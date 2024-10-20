//
//  CartCell.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import UIKit

protocol CellProtocol {
    func deleteButtonTapped(indexPath: IndexPath)
    func decrementCartProduct(indexPath: IndexPath)
    func incrementCartProduct(indexPath: IndexPath)
}

class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var stepperStackView: UIStackView!
    
    
    var cellProtocol: CellProtocol?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var onRemoveButtonTapped: (() -> Void)?
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        //cellProtocol?.deleteButtonTapped(indexPath: indexPath!)
        
         onRemoveButtonTapped?()
    }
    
    @IBAction func decrementButtonTapped(_ sender: Any) {
        cellProtocol?.decrementCartProduct(indexPath: indexPath!)
    }
    
    @IBAction func incrementButtonTapped(_ sender: Any) {
        cellProtocol?.incrementCartProduct(indexPath: indexPath!)
    }
    
}
