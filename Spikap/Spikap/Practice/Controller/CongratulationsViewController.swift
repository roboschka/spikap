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
    var totalPoints: Int = 20
    
    
    //MARK: IB Outlet
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var goodWorkLabel: UILabel!
    @IBOutlet weak var XPLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //totalPoints
        UserDefaults.standard.set(totalPoints, forKey: "guestPoints")
        guestStruct.guestPoints = guestStruct.guestPoints + UserDefaults.standard.integer(forKey: "guestPoints")
        
        //isTodayDone
        UserDefaults.standard.set(true, forKey: "isTodayDone")
        guestStruct.isTodayDone = UserDefaults.standard.bool(forKey: "isTodayDone")
        
        //daysOnStreak
        if (guestStruct.isOnStreak) {
            UserDefaults.standard.set(guestStruct.daysOnStreak + 1, forKey: "daysOnStreak")
            guestStruct.daysOnStreak = UserDefaults.standard.integer(forKey: "daysOnStreak")
        }
        
        //isOnStreak
        UserDefaults.standard.set(true, forKey: "isOnStreak")
        guestStruct.isOnStreak = UserDefaults.standard.bool(forKey: "isOnStreak")
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
