//
//  layoutHelper.swift
//  Spikap
//
//  Created by Grace Cindy on 23/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import UIKit



class FontHelper {
    public static func getCompactRoundedFont(fontSize : CGFloat, fontWeight : UIFont.Weight) -> UIFont
    {
        
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let customFont: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded)
        {
            customFont = UIFont(descriptor: descriptor, size: fontSize)
        }
        else
        {
            customFont = systemFont
        }
        
        return customFont
        
    }
}

