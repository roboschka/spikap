//
//  CongratulationsViewController.swift
//  Spikap
//
//  Created by Maria Jeffina on 23/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class CongratulationsViewController: UIViewController {
    //MARK: Variables
    var totalPoints: Int = 100
    
    
    //MARK: IB Outlet
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var goodWorkLabel: UILabel!
    @IBOutlet weak var XPLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(totalPoints, forKey: "guestPoints")
        guestStruct.guestPoints = guestStruct.guestPoints + UserDefaults.standard.integer(forKey: "guestPoints")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeToSystemFont(label: congratsLabel, fontSize: 32)
        goodWorkLabel.text = "Keep up the good work! Remember, good habits are keys to success."
        XPLabel.text = "\(totalPoints) XP Point(s)"
        
    }
    
    @IBAction func backToPractice(_ sender: AnyObject) {
//        let practicePage = storyboard?.instantiateViewController(identifier: "practiceView") as! practiceVC
//        self.present(practicePage, animated: true, completion: nil)
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
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
