//
//  ChallengeCollectionViewCell.swift
//  Spikap
//
//  Created by Muhammad Rivan Rayhan on 24/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class ChallengeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var daysLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.daysView.layer.cornerRadius = 0.5 * self.daysView.bounds.size.width

        // Initialization code
    }
    override var isSelected: Bool {
        didSet {
            self.daysView.layer.borderColor = UIColor.black.cgColor
            self.daysView.layer.borderWidth = isSelected ? 2 : 0
        }
        
    }
    
    
}
