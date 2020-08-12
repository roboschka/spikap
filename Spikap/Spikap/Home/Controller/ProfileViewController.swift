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
    @IBOutlet var imageProfile: UIButton!
    
    var users: userModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        loadprofile()
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
        editProfileBtn.isHidden = false
        
        nameLabel.font = FontHelper.getCompactRoundedFont(fontSize: nameLabel.font.pointSize, fontWeight: .bold)
        userLevelLabel.font = FontHelper.getCompactRoundedFont(fontSize: userLevelLabel.font.pointSize, fontWeight: .regular)
        userPostCountLabel.font = FontHelper.getCompactRoundedFont(fontSize: 30, fontWeight: .regular)
        userPointCountLabel.font = FontHelper.getCompactRoundedFont(fontSize: 30, fontWeight: .regular)
        userBadgeCountLabel.font = FontHelper.getCompactRoundedFont(fontSize: 30, fontWeight: .regular)
        
    }
    
    func loadprofile() {

        
        if let asset = users?.imageProfile, let data = try? Data(contentsOf: asset.fileURL!), let image = UIImage(data: data) {
            //               cell.practiceDetailImage.image = image
            imageProfile.setImage(image, for: .normal)
            imageProfile.imageView?.layer.cornerRadius = imageProfile.bounds.width * 0.5
        }
        nameLabel.text = users?.fullname
        userLevelLabel.text = users?.userLevel

        if let point = users?.userPoints {
        userPointCountLabel.text = "\(point)"
        } else {
            print("Doesn’t contain a number")
        }
       

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProfileVC = segue.destination as? EditProfileVC {
           editProfileVC.users = sender as? userModel
        }
    }
    
    @IBAction func EditButton(_ sender: Any) {
        self.performSegue(withIdentifier: "editProfile", sender: users)
    }

}
