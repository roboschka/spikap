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
        let userRecord = CKRecord(recordType: "Members")
        
        //Record or Table properties
        userRecord["userID"] = 1 as CKRecordValue
        userRecord["userEmail"] = userEmail as CKRecordValue
        userRecord["firstName"] = fullName as CKRecordValue
        userRecord["daysOnStreak"] = 0 as CKRecordValue
        userRecord["isOnStreak"] = true as CKRecordValue
        userRecord["userPoints"] = 0 as CKRecordValue
        
        let myContainer = CKContainer.init(identifier: "iCloud.com.aries.Spikap")
        let privateDatabase = myContainer.publicCloudDatabase
        
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
    

//    static func getMemberBySpecificEmail(email:String, successCompletion:@escaping (userModel) -> Void, failCompletion:@escaping(String) -> Void){
//        // use default container, we can set custom container by setting
//        let myContainer = CKContainer.init(identifier: "iCloud.com.aries.Spikap")
//        let privateContainer = myContainer.publicCloudDatabase
//
//        // fecth with array
//        let predicate = NSPredicate(format: "userEmail = %@", email)
//        let query = CKQuery(recordType: "Members", predicate: predicate)
//        var model = userModel()
//
//        privateContainer.perform(query, inZoneWith: nil) { (result, error) in
//            if let err = error {
//                print(err.localizedDescription)
//                return
//            }
//
//            if let records = result {
//                print("\n\n")
//                records.forEach{
//                    print($0)
//                    guard let userEmail = $0["userEmail"], let fullname = $0["firstName"], let userPoints = $0["userPoints"], let daysOnStreak = $0["daysOnStreak"], let isOnStreak = $0["isOnStreak"] else {return}
//
//                    model.userEmail = userEmail as! String
//                    model.fullname = fullname as! String
//                    model.userPoints = userPoints as! Int
//                    model.daysOnStreak = daysOnStreak as! Int
//                    model.isOnStreak = isOnStreak as! Bool
//                    successCompletion(model)
//                }
//                print("\n\n")
//            }
//
//        }
//    }
}
