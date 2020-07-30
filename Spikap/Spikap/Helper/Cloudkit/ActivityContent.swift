//
//  ActivityContent.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 29/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//



import Foundation
import CloudKit

class ActivityContent {
    
    private let id: CKRecord.ID
       let activityReference: CKRecord.Reference?
       let content: String
       let contentToken: [String]
       let info: [String]
       let result: Int
       let forDay: Int
     
    init(record: CKRecord){
        id = record.recordID
        content = record["content"] as? String ?? ""
        contentToken = record["contentToken"] as? [String] ?? [""]
        info = record["info"] as? [String] ??  [""]
        result = record["result"] as? Int ?? 0
        forDay = record["forDay"] as? Int ?? 0
        activityReference = record["activityReference"] as? CKRecord.Reference
    }
      
    
    static func fetchActivitiesContent(_ completion: @escaping (Result<[ActivityContent], Error>) -> Void){
        let query = CKQuery(recordType: "ActivityContent", predicate: NSPredicate(value: true))
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
            
            let activiticontent = results.map(ActivityContent.init)
            
            DispatchQueue.main.async {
                completion(.success(activiticontent))
            }
        }
    }
    
    static func fetchActivitiesContent(for references: [CKRecord.Reference], _ completion: @escaping ([ActivityContent]) -> Void) {
        let recordIDs = references.map { $0.recordID }
        let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
        
        operation.qualityOfService = .utility
        operation.fetchRecordsCompletionBlock = { records, error in
            let activiticontent = records?.values.map(ActivityContent.init) ?? []
            DispatchQueue.main.async {
                completion(activiticontent)
            }
        }
        Model.currentModel.publicDB.add(operation)
    }
    
}
