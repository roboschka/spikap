//
//  communityVC.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 10/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class communityVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar(largeTitleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 0.8980392157, alpha: 1), tintColor: .white, title: "Community", preferredLargeTitle: true, fontSize: 40)
        UIApplication.shared.statusBarUIView?.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 0.8980392157, alpha: 1)
        
        showPage()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showPage()
    {
        let user_status : Bool = false
        //check user login status
        if user_status {
            //if logged in
            //show main community page
        }
        else
        {
            //if not logged in
            //show alert
            showAlert(alert_title: "You are not Signed In", alert_message : "You need to login to access Community")
        }
    }
    
    func showAlert(alert_title:String, alert_message:String)
    {
        // create the alert
        let alert = UIAlertController(title: alert_title, message: alert_message, preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Sign In", style: UIAlertAction.Style.default, handler: {
                (action:UIAlertAction!) in self.goToLogin()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToLogin()
    {
        //go to login function
        print("go to login")
    }
    
    

}
