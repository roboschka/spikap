//
//  User.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 28/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//


import Foundation
import UIKit
import CloudKit

class userModel: NSObject {
    var userID = 0
    var fullname : String!
    var userEmail : String!
    var daysOnStreak : Int!
    var isOnStreak : Bool!
    var isTodayDone: Bool!
    var userPoints : Int!
    var userLevel: String!
    var imageProfile: CKAsset!
    var activeNames: [String:Int] = ["Challenge A": 6, "Challenge B": 4]
}
 var currentUser = userModel()
