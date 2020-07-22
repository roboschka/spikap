//
//  onboardVC.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 10/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import AuthenticationServices

class LandingTabBarVC: UITabBarController {
    var currentUser = [User]()
    let currentGuest = GuestModel()
    var showOnboarding = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showOnboarding = UserDefaults.standard.bool(forKey: "showOnboarding")
    }
    enum ViewControllerType {
        case welcome
        case home
    }
    //MARK: Check if user is signed in or not
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showOnboarding == true {
//            pushTo(viewController: .home)
        }else {
            //            pushTo(viewController: .home)
            pushTo(viewController: .welcome)
            showOnboarding =  true
            UserDefaults.standard.set(showOnboarding, forKey: "showOnboarding")
        }
    }
    
    //MARK: Push to relevant ViewController
    func pushTo(viewController: ViewControllerType)  {
        switch viewController {
        case .home:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LandingTabBarVC") as! UITabBarController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        case .welcome:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            //vc.isModalInPresentation = true
            self.present(vc, animated: true, completion: nil)
        }
    }
}




