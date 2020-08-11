//
//  ActivityData.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 03/08/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class activityData: NSObject {
    var recordID: CKRecord.ID!
    var name: String!
    var topic: String!
    var level: String!
    var coverImage: CKAsset!
    var continueImage: CKAsset!
    var totalProgress: Int!
    var activityTypeId: CKRecord.ID!
}
