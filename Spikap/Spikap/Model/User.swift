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
    var userPoints : Int!
    var userLevel: String!
}
