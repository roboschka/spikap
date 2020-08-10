//
//  Activity.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 29/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import CloudKit

class Activity {
 
    private let id: CKRecord.ID
    let activitytypeReference: CKRecord.Reference?
    let name: String
    let level: String
    let topic: String
    let totalProgress: Int
    let totalPoint: Int
    let coverImage: CKAsset?
    private(set) var contents: [ActivityContent]? = nil
//    private(set) var overviews: [ActivityOverview]? = nil
    
    init(record: CKRecord) {
        name = record["name"] as? String ?? ""
        level = record["level"] as? String ?? ""
        topic = record["topic"] as? String ?? ""
        id = record.recordID
        activitytypeReference = record["activityTypeID"] as? CKRecord.Reference
        totalProgress = record["totalProgress"] as? Int ?? 0
        totalPoint = record["totalPoint"] as? Int ?? 0
        coverImage = record["coverImage"] as? CKAsset
        
        if let activityContentRecords = record["contents"] as? [CKRecord.Reference]{
          ActivityContent.fetchActivitiesContent(for: activityContentRecords) {
              contents in self.contents = contents
          }
        }
        
        if let activityOverviewRecords = record["overviews"] as? [CKRecord.Reference]{
//            ActivityOverview.fetchActivitiesOverview(for: activityOverviewRecords) {
//                overviews in self.overviews = overviews
//            }
        }
        
    }
    
    static func fetchActivities(_ completion: @escaping (Result<[Activity], Error>) -> Void){

       let query = CKQuery(recordType: "Activity", predicate: NSPredicate(value: true))
       let container = CKContainer.init(identifier: "iCloud.com.aries.Spikap")
       container.publicCloudDatabase.perform(query, inZoneWith: nil) { results, error in
         
         if let error = error {
           DispatchQueue.main.async {
             completion(.failure(error))
           }
           return
         }
         
         guard let results = results else {
           DispatchQueue.main.async {
             let error = NSError( domain: "com.babifud", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not download notes"])
             completion(.failure(error))
           }
           return
         }
         
        let activities = results.map(Activity.init)
         
         DispatchQueue.main.async {
            completion(.success(activities))
         }
       }
    }
     
    static func fetchActivities(for references: [CKRecord.Reference], _ completion: @escaping ([Activity]) -> Void) {
        let recordIDs = references.map { $0.recordID }
        let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
        
        operation.qualityOfService = .utility
        operation.fetchRecordsCompletionBlock = { records, error in
            let activities = records?.values.map(Activity.init) ?? []
            DispatchQueue.main.async {
                completion(activities)
            }
        }
        Model.currentModel.publicDB.add(operation)
    }
    
}
