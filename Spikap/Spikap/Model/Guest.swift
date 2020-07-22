//
//  Guest.swift
//  Spikap
//
//  Created by Maria Jeffina on 21/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import UIKit

struct GuestModel {
    var daysOnStreak: Int = 0
    var isOnStreak: Bool = false
    var isTodayDone: Bool = false
    var guestPoints: Int = 0
    var guestLevel: String = "Beginner"
    var activitiesId: [String] = []
    var badgesId: [String] = []
}

var guestStruct = GuestModel()
