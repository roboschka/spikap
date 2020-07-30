//
//  ActiviityType.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 29/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import MapKit
import CloudKit
import CoreLocation


class ActivityType {
    
    static let recordType = "ActivityType"
    private let id: CKRecord.ID
    let typename: String
    let database: CKDatabase
    
    private(set) var activities: [Activity]? = nil
    
    init?(record: CKRecord, database: CKDatabase) {
        guard let typename = record["typeName"] as? String else { return nil }
        
        id = record.recordID
        self.typename = typename
        self.database = database
        
        if let activityRecords = record["activities"] as? [CKRecord.Reference]{
          Activity.fetchActivities(for: activityRecords) {
              activities in self.activities = activities
          }
        }
    }
}

extension ActivityType: Hashable {
  static func == (lhs: ActivityType, rhs: ActivityType) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
