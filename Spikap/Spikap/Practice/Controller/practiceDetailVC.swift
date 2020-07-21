//
//  practiceDetailVC.swift
//  Spikap
//
//  Created by Muhammad Rivan Rayhan on 21/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class practiceDetailVC: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    var practiceTypeId:Int?
    let practiceBackgroundImage:[UIImage] = [#imageLiteral(resourceName: "challenge background"),#imageLiteral(resourceName: "self talk background"),#imageLiteral(resourceName: "speech shadowing background")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backgroundImageView.image = practiceBackgroundImage[practiceTypeId!]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
