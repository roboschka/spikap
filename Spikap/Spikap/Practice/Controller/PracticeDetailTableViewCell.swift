//
//  PracticeDetailTableViewCell.swift
//  Spikap
//
//  Created by Muhammad Rivan Rayhan on 22/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class PracticeDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var practiceDetailLabel: UILabel!
    @IBOutlet weak var practiceDetailImage: UIImageView!
    @IBOutlet weak var practiceTopicLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        changeToSystemFont(label: practiceDetailLabel, fontSize: 24)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
