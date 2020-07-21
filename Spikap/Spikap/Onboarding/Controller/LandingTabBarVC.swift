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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           let appleIDProvider = ASAuthorizationAppleIDProvider()
           appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier ?? "") { (credentialState, error) in
               switch credentialState {
               case .authorized:
                   /* DispatchQueue.main.async {
                       self.pushTo(viewController: .home)
                   } */
                   
                   //MARK: - Core Data
   //                self.currentUser = self.helper.fetchUserByEmail(email: KeychainItem.currentUserEmail ?? "") as [User]
   //                if self.currentUser.count >= 1{
   //                    currentUserID = Int(self.currentUser[0].userID)
   //                    userEmail = self.currentUser[0].email!
   //                    userFullName = self.currentUser[0].fullName
   //                }
                   
                   //MARK: - CloudKit
                   User.getMemberBySpecificEmail(email: KeychainItem.currentUserEmail ?? "")
                   print("\n\nCurrentUserID = \(String(describing: currentUserID))\n\nUserEmail = \(String(describing: userEmail))\n\nUserFullName = \(String(describing: userFullName))\n\n")
                   
                   break // The Apple ID credential is valid.
               case .revoked, .notFound:
                   // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                   User.countAllMember()
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                       self.pushTo(viewController: .welcome)
                   }
               default:
                   break
               }
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
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnboardVC") as! OnboardVC
               vc.modalPresentationStyle = .fullScreen
               //vc.isModalInPresentation = true
               self.present(vc, animated: true, completion: nil)
           }
       }
       

}
