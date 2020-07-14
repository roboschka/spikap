//
//  userExtention.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 14/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import CloudKit

class User {
    static func createUser(userID: String, userEmail: String, userPassword: String, firstName: String, lastName: String, daysOnStreak: Int, isOnStreak: Bool, userPoints: Int){
        let userRecord = CKRecord(recordType: "Members")
        
        //Record or Table properties
        userRecord["userID"] = userID as CKRecordValue
        userRecord["userEmail"] = userEmail as CKRecordValue
        userRecord["userPassword"] = userPassword as CKRecordValue
        userRecord["firstName"] = firstName as CKRecordValue
        userRecord["lastName"] = lastName as CKRecordValue
        userRecord["daysOnStreak"] = daysOnStreak as CKRecordValue
        userRecord["isOnStreak"] = isOnStreak as CKRecordValue
        userRecord["userPoints"] = userPoints as CKRecordValue
        
        let myContainer = CKContainer.init(identifier: "iCloud.com.aries.Spikap")
        let privateDatabase = myContainer.privateCloudDatabase
        
        print("myContainer", myContainer)
        print("privateDatabse ", privateDatabase)
        privateDatabase.save(userRecord) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("\n\ncreate user is Error: \(error.localizedDescription)\n\n")
                } else {
                    print("\n\ncreate user is Done!\n\n")
                }
            }
        }
    }
}
