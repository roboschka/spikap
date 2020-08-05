//
//  LoginViewController.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 21/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet var Continue: UIView!
    @IBOutlet var GuestLogin: UIButton!
    
    @IBOutlet var loginProviderStackView: UIStackView!
    
    var dayOnstreak = 1
    var isOnstreak = false
    var isTodayDone = false
    var points = 1
    var levelName = "Beginner"
    var activitiesId = ["123","111"]
    var badgesId = ["1","2"]
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
        configureNavigationBar(largeTitleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 0.8980392157, alpha: 1), tintColor: .white, title: "", preferredLargeTitle: true, fontSize: 40)
//        GuestLogin.setGradientColor(colorOne: #colorLiteral(red: 1, green: 0.6156862745, blue: 0.3137254902, alpha: 1), colorTwo: #colorLiteral(red: 1, green: 0.6980392157, blue: 0.2980392157, alpha: 1))
        GuestLogin.layer.cornerRadius = 10
        GuestLogin.layer.masksToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    func setupProviderLoginView() {
        let isDarkTheme = view.traitCollection.userInterfaceStyle == .dark
        let style: ASAuthorizationAppleIDButton.Style = isDarkTheme ? .black : .black
        
        let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: style)
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        
        let heightConstraint = authorizationButton.heightAnchor.constraint(equalToConstant: 44)
        authorizationButton.addConstraint(heightConstraint)
        
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    @IBAction func guestLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LandingTabBarVC") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        KeychainItem.currentUserIdentifier = nil
        KeychainItem.currentUserGivenName = nil
        KeychainItem.currentUserBirthName = nil
        KeychainItem.currentUserEmail = nil
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account in your system.
            // For the purpose of this demo app, store the these details in the keychain.
            KeychainItem.currentUserIdentifier = appleIDCredential.user
            KeychainItem.currentUserGivenName = appleIDCredential.fullName?.givenName
            KeychainItem.currentUserBirthName = appleIDCredential.fullName?.familyName
            KeychainItem.currentUserEmail = appleIDCredential.email
            //                    users = UserModel(credentials: appleIDCredential)
            
            guard let firstName = appleIDCredential.fullName?.givenName else { return }
            guard let lastName = appleIDCredential.fullName?.familyName else { return }
            let fullName = firstName + " " + lastName
            guard let email = appleIDCredential.email else { return }
            
            
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
            }
            
//            self.performSegue(withIdentifier: "login", sender: email)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LandingTabBarVC") as! UITabBarController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
            //Show Home View Controller
//            self.dismiss(animated: true, completion: nil)
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let homeuserVC = segue.destination as? homeVC {
//            homeuserVC.userFromLogin  = sender as? userModel
        }
    }
    
    
    private func showResultViewController(fullName: String?, email: String?) {
        
        guard let viewController = self.presentingViewController as? homeVC
            else { return }
        viewController.userNameLabel.text = fullName
        DispatchQueue.main.async {
            viewController.userNameLabel.text = fullName
            self.dismiss(animated: true, completion: nil)
        }
    
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "aries.Spikap", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
//    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
//        guard let viewController = self.presentingViewController as? homeVC
//            else { return }
//
//        DispatchQueue.main.async {
////            viewController.showOnboarding = true
//
//            if let givenName = fullName?.givenName {
//                viewController.userNameLabel.text = givenName
//            }
////            if let familyName = fullName?.familyName {
////                viewController.familyNameLabel.text = familyName
////            }
////            if let email = email {
////                viewController.emailLabel.text = email
////            }
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
            loginViewController.modalPresentationStyle = .overFullScreen
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}
