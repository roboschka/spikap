//
//  ActivityType.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 03/08/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//


import Foundation
import UIKit
import CloudKit

class activityTypeData: NSObject {
    var recordID: CKRecord.ID!
    var typeName: String!
    var activites = [CKRecord.ID]()
    var coverImage: CKAsset!
    var cardImage: CKAsset!
}


