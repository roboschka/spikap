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
//    var currentUser = [User]()
    var datamodel = userModel()
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
        
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier ?? "") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                //MARK: - CloudKit
                Userextention.getMemberBySpecificEmail(email: "ariesdwiprasetiyo4@gmail.com", successCompletion: { (datamodel) in
                    self.datamodel = datamodel
                    print("\n\nPoint = \(datamodel.userPoints)\n\nUserEmail = \(datamodel.userEmail)\n\nUserFullName = \(datamodel.fullname)\n\n")
                }){
                    (message)in
                    print(message)
                }
                
            break // The Apple ID credential is valid.
            case .revoked, .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    self.pushTo(viewController: .welcome)
                }
            default:
                break
            }
        }
        //        if showOnboarding == true {
        //
        ////            pushTo(viewController: .home)
        //
        //        }else {
        //            //            pushTo(viewController: .home)
        //            pushTo(viewController: .welcome)
        //            showOnboarding =  true
        //            UserDefaults.standard.set(showOnboarding, forKey: "showOnboarding")
        //        }
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




