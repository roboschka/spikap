//
//  Model.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 29/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import CloudKit

class Model {
  // MARK: - iCloud Info
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    init() {
        container = CKContainer.init(identifier: "iCloud.com.aries.Spikap")
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    // MARK: - Properties
    private(set) var activitytypes: [ActivityType] = []
    static var currentModel = Model()

    @objc func refresh(_ completion: @escaping (Error?) -> Void) {
      // 1.
      let predicate = NSPredicate(value: true)
      // 2.
      let query = CKQuery(recordType: "ActivityType", predicate: predicate)
      activitytype(forQuery: query, completion)
    }
    
    private func activitytype(forQuery query: CKQuery, _ completion: @escaping (Error?) -> Void) {
       publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID){
         [weak self] results, error in guard let self = self else { return }
         if let error = error {
           DispatchQueue.main.async {
             completion(error)
           }
           return
         }
         guard let results = results else { return }
         self.activitytypes = results.compactMap {
           ActivityType(record: $0, database: self.publicDB)
         }
         DispatchQueue.main.async {
           completion(nil)
         }
       }
     }
    
}
