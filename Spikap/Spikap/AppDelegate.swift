//
//  AppDelegate.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 08/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import CoreData
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
   /// - Tag: did_finish_launching
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier ?? "") { (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    let email = KeychainItem.currentUserEmail ?? ""
////                        DispatchQueue.main.async {
////                        self.window?.rootViewController?.showLoginViewController()
//
//
//
//                    break // The Apple ID credential is valid.
//                case .revoked, .notFound:
//                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                    DispatchQueue.main.async {
//                        self.window?.rootViewController?.showLoginViewController()
//                    }
//                default:
//                    break
//                }
//            }
            return true
        }

//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

