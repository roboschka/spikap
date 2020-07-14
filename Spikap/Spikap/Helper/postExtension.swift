//
//  postExtension.swift
//  Spikap
//
//  Created by Maria Jeffina on 14/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import Foundation
import CloudKit

class Post {
    static func createPosts(postID: String, postTitle: String, postAudio: String, postLikes: Int, userID: String){
        let postRecord = CKRecord(recordType: "Posts")
        
        //Record or Table properties
        postRecord["postID"] = postID as CKRecordValue
        postRecord["postTitle"] = postTitle as CKRecordValue
        postRecord["postAudio"] = postAudio as CKRecordValue
        postRecord["postLikes"] = postLikes as CKRecordValue
        postRecord["userID"] = userID as CKRecordValue
        
        let myContainer = CKContainer.init(identifier: "iCloud.com.aries.Spikap")
        let publicDatabase = myContainer.publicCloudDatabase
        
        print("myContainer", myContainer)
        print("publicDatabase ", publicDatabase)
        publicDatabase.save(postRecord) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("\n\ncreate history is Error: \(error.localizedDescription)\n\n")
                } else {
                    print("\n\ncreate history is Done!\n\n")
                }
            }
        }
    }
}
