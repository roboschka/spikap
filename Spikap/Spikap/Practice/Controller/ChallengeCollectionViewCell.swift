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
            self.daysView.backgroundColor = isSelected ? UIColor(red: 255/255, green: 157/255, blue: 80/255, alpha: 1) : UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
            self.daysLabel.textColor = isSelected ? UIColor.white : UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1)
        }
        
    }
    
    
}
