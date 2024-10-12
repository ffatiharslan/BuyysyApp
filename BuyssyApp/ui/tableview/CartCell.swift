//
//  CartCell.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import UIKit

protocol CellProtocol {
    func deleteButtonTapped(indexPath: IndexPath)
}

class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    
    var cellProtocol: CellProtocol?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        cellProtocol?.deleteButtonTapped(indexPath: indexPath!)
    }
}
