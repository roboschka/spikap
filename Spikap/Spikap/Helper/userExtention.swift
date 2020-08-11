//
//  userExtention.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 14/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import CloudKit

class Userextention {
    static func createUser(fullName:String,userEmail:String){
       let myContainer = CKContainer.init(identifier: "iCloud.com.aries.Spikap")
        let privateDatabase = myContainer.publicCloudDatabase
        let userRecord = CKRecord(recordType: "Members")
        
        //Record or Table properties
        userRecord["userID"] = 1 as CKRecordValue
        userRecord["userEmail"] = userEmail as CKRecordValue
        userRecord["firstName"] = fullName as CKRecordValue
        userRecord["daysOnStreak"] = 0 as CKRecordValue
        userRecord["isOnStreak"] = true as CKRecordValue
        userRecord["userPoints"] = 0 as CKRecordValue
         userRecord["levelName"] = "Beginner" as CKRecordValue
        userRecord["isTodayDone"] = 1 as CKRecordValue
       
        
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
