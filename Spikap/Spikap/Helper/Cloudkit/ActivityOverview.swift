//
//  ActivityOverview.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 29/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//


import Foundation
import CloudKit

class ActivityOverview {
 
    static func fetchActivitiesOverview(_ completion: @escaping (Result<[ActivityOverview], Error>) -> Void){
        
    }
    
    static func fetchActivitiesOverview(for references: [CKRecord.Reference], _ completion: @escaping ([ActivityOverview]) -> Void) {
    }
}
