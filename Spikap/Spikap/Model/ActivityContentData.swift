//
//  ActivityContentData.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 03/08/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//
import Foundation
import CloudKit
import UIKit

class activityContentData: NSObject {
    var recordID: CKRecord.ID!
    var activity: CKRecord.ID!
    var contents: String!
    var contentToken: [String]!
    var forDay: Int!
    var info: [String]!
    var result: Int!
}
