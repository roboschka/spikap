//
//  ProfileViewController.swift
//  Spikap
//
//  Created by Maria Jeffina on 21/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var userPostCountLabel: UILabel!
    @IBOutlet weak var userPointCountLabel: UILabel!
    @IBOutlet weak var userBadgeCountLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupLayout()
    {
        //hide edit profile button
        editProfileBtn.isHidden = true
        
        nameLabel.font = FontHelper.getCompactRoundedFont(fontSize: 20, fontWeight: .bold)
        userLevelLabel.font = FontHelper.getCompactRoundedFont(fontSize: 18, fontWeight: .regular)
        userPostCountLabel.font = FontHelper.getCompactRoundedFont(fontSize: 30, fontWeight: .regular)
        userPointCountLabel.font = FontHelper.getCompactRoundedFont(fontSize: 30, fontWeight: .regular)
        userBadgeCountLabel.font = FontHelper.getCompactRoundedFont(fontSize: 30, fontWeight: .regular)
        
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
