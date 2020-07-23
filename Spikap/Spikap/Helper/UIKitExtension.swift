//
//  UIKitExtension.swift
//  Spikap
//
//  Created by Maria Jeffina on 15/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import UIKit

//MARK: UIViewController Extension
extension UIViewController {
    
    
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return false
        }
    }
    
    func configureNavigationBar(largeTitleColor: UIColor, backgroundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool, fontSize: CGFloat) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            let fontSize: CGFloat = fontSize
            let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            let font : UIFont
            
            if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
                font = UIFont(descriptor: descriptor, size: fontSize)
            } else {
                font = systemFont
            }
            
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor, .font: font]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor, .font: font]
            navBarAppearance.backgroundColor = backgroundColor
            
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.barStyle = .black
            
            navigationItem.title = title
        } else {
            // For earlier iOS versions
            navigationController?.navigationBar.barTintColor = backgroundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = true
            navigationItem.title = title
        }
    }
    
    func changeToSystemFont(label: UILabel, fontSize: CGFloat) {
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        let font : UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            font = systemFont
        }
        
        return label.font = font
    }

}

extension UITableViewCell {
    func changeToSystemFont(label: UILabel, fontSize: CGFloat) {
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        let font : UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            font = systemFont
        }
        
        return label.font = font
    }
}


extension UIView {
    func setGradientColor(colorOne: UIColor, colorTwo:UIColor ){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0 , 0.1]
        gradientLayer.startPoint = CGPoint(x: 1.0 , y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}


extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}
