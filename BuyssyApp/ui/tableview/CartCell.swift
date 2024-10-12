//
//  CartCell.swift
//  BuyssyApp
//
//  Created by fatih arslan on 12.10.2024.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var brandLabel: UILabel!
    
    @IBOutlet weak var adetLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
}
