//
//  responseCollectionViewCell.swift
//  ChatBot
//
//  Created by Chandan verma on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import UIKit

class ResponseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var interestedSwitch: UISwitch!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearOfManufacture: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func prepareForReuse() {
    }
    
    func refreshUI() {
        
    }
    
    @IBAction func didClickMoreButton(_ sender: UIButton) {
        
    }
    
}
