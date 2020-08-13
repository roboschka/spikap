//
//  Guest.swift
//  Spikap
//
//  Created by Maria Jeffina on 21/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

struct GuestModel {
    var daysOnStreak: Int = 0
    var isOnStreak: Bool = false
    var isTodayDone: Bool = false
    var guestPoints: Int = 0
    var guestLevel: String = "Beginner"
    var activeNames: [String:Int] = ["Challenge A": 1]
    var badgesId: [String] = []
    
//    var currentActivity: [activityContentData] = []
}

var guestStruct = GuestModel()
