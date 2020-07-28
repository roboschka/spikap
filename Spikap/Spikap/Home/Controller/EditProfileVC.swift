//
//  EditProfileVC.swift
//  Spikap
//
//  Created by Grace Cindy on 23/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var profileInfoLabel: UILabel!
    @IBOutlet weak var interestBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
        setupPicture()
    }
    
    func setupPicture()
    {
        let color = UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        profileImage.backgroundColor = color
        profileImage.layer.cornerRadius = 0.5 * profileImage.bounds.size.width
        //change user's picture here
        profileImage.image = #imageLiteral(resourceName: "person1")
        
    }
    
    //example to use SF Compact Rounded from Helper Class
    func setupLayout()
    {
        let roundedFont = FontHelper.getCompactRoundedFont(fontSize: 22, fontWeight: .bold)
        profileInfoLabel.font = roundedFont
    }
    
    //example to use SF Compact Rounded locally
    func setupLayout2()
    {
        let systemFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        let customFont: UIFont
        
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded)
        {
            print("font rounded ok")
            customFont = UIFont(descriptor: descriptor, size: 22)
        }
        else
        {
            print("unable to round font")
            customFont = systemFont
        }
        
        profileInfoLabel.font = customFont
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
