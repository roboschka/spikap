//
//  practiceDetailVC.swift
//  Spikap
//
//  Created by Muhammad Rivan Rayhan on 21/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import CloudKit

class practiceDetailVC: UIViewController {
    
    @IBOutlet weak var practiceDetailTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var activities = [activityData]()
    
    var practiceTypeId:Int = 0
    var activityType: activityTypeData!
    
    let practiceBackgroundImage:[UIImage] = [#imageLiteral(resourceName: "challenge background"),#imageLiteral(resourceName: "self talk background"),#imageLiteral(resourceName: "speech shadowing background")]
    var practiceDetail:[String] = ["testDetail"]
    var practiceTopic:[String] = ["test"]
    var practiceImage:[UIImage] = [#imageLiteral(resourceName: "challenge a"),#imageLiteral(resourceName: "challenge b"),#imageLiteral(resourceName: "challenge c")]
    var practiceId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        practiceDetailTableView.register(UINib(nibName: "PracticeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "practiceDetailCell")
        practiceDetailTableView.delegate = self
        practiceDetailTableView.dataSource = self
        if let asset = activityType.coverImage,
           let data = try? Data(contentsOf: asset.fileURL!),
           let image = UIImage(data: data) {
            backgroundImageView.image = image
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadActivities()
        practiceDetailTableView.reloadData()
    }
    
    //MARK: Load Activity by ActivityTypeID
    func loadActivities() {
        activities = []
        let idToFetch = CKRecord.Reference(recordID: activityType.recordID, action: .none)
        let pred = NSPredicate(format: "activityTypeID = %@", idToFetch)
        let query = CKQuery(recordType: "Activity", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 99
        
        var fetchActivities = [activityData]()
        
        operation.recordFetchedBlock = {
            record in
            let activity  = activityData()
            activity.recordID = record.recordID
            activity.name = record["name"]
            activity.topic = record["topic"]
            activity.level = record["level"]
            activity.coverImage = record["coverImage"]
            activity.totalProgress = record["totalProgress"]
            
            fetchActivities.append(activity)
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.activities = fetchActivities
                    self.practiceDetailTableView.reloadData()
                } else {
                    print("Error fetching data")
                }
            }
        }
        
        CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.add(operation)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let challengeVC = segue.destination as? ChallengeOverviewViewController {
            challengeVC.practiceId = sender as? Int
        }
        if let SpeechShadowing = segue.destination as? SpeechShadowingViewController {
           SpeechShadowing.activity = sender as? activityData
        }
    }
}

extension practiceDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "practiceDetailCell") as! PracticeDetailTableViewCell
        cell.selectionStyle = .none
        if let asset = activities[indexPath.row].coverImage, let data = try? Data(contentsOf: asset.fileURL!), let image = UIImage(data: data) {
            cell.practiceDetailImage.image = image
        }
        cell.practiceTopicLabel.text = activities[indexPath.row].topic
        cell.practiceDetailLabel.text = activities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(activities)
        self.performSegue(withIdentifier: "segueToSpeechShadowing", sender: activities[indexPath.row])
    }
    
 }
