//
//  ActivityOverview.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 10/08/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class activityOverviewData: NSObject {
    var recordID: CKRecord.ID!
    var activity: CKRecord.ID!
    var overviewProgress: String!
    var forDay: Int!
}
