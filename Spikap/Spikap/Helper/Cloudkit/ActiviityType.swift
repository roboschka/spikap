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
    let coverImage: CKAsset?
    
    private(set) var activities: [Activity]? = nil
    
    init?(record: CKRecord, database: CKDatabase) {
        guard let typename = record["typeName"] as? String else { return nil }
        
        id = record.recordID
        self.typename = typename
        self.database = database
        coverImage = record["coverImage"] as? CKAsset
        
        if let activityRecords = record["activities"] as? [CKRecord.Reference]{
          Activity.fetchActivities(for: activityRecords) {
              activities in self.activities = activities
          }
        }
    }
    
    func loadCoverPhoto(completion: @escaping (_ photo: UIImage?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
          
          var image: UIImage?
          defer {
            DispatchQueue.main.async {
              completion(image)
            }
          }
          
          guard let coverPhoto = self.coverImage, let fileURL = coverPhoto.fileURL else { return }
          
          let imageData: Data
          do {
            imageData = try Data(contentsOf: fileURL)
          } catch {
            return
          }
          
          image = UIImage(data: imageData)
        
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
