//
//  ChallengeOverviewViewController.swift
//  Spikap
//
//  Created by Muhammad Rivan Rayhan on 23/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import CloudKit

class ChallengeOverviewViewController: UIViewController {

    
    @IBOutlet weak var challengeOverviewImage: UIImageView!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var dayDescriptionLabel: UILabel!
    @IBOutlet weak var practiceTypeLabel: UILabel!
    @IBOutlet weak var practiceLevelLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    var image:[UIImage] = [#imageLiteral(resourceName: "challenge a background"),#imageLiteral(resourceName: "challenge b background")]
    var activity: activityData!
    var activityToPass: activityData!
    var activityOverviews = [activityOverviewData]()
    var practiceId:Int?
    var challengeDesc:[String] = ["Practice your pronunciation using Vacation topic in speech shadowing","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your pronunciation using Vacation topic in speech shadowing","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your pronunciation using Vacation topic in speech shadowing","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your speaking skills using Travelling topic in self-talk","Practice your speaking skills using Job Interview topic in self-talk","Practice your speaking skills using Ordering food topic in self-talk","Practice your speaking skills using Travelling topic in self-talk","Practice your speaking skills using Job Interview topic in self-talk","Practice your speaking skills using Ordering food topic in self-talk","Practice your speaking skills using Travelling topic in self-talk","Practice your speaking skills using Job Interview topic in self-talk","Practice your speaking skills using Ordering food topic in self-talk","Go to community and post any topic you like","Go to community and post any topic you like","Go to community and post any topic you like"]
    var forDay:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        collectionView.register(UINib(nibName: "ChallengeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "challengeCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.selectItem(at: IndexPath.init(item: forDay, section: 0), animated: true, scrollPosition: [])
        dayLabel.text = "Day \(forDay + 1)"
        dayDescriptionLabel.text = challengeDesc[forDay]
        loadData()
        loadOverview()
    }
    
    func loadOverview() {

        activityOverviews = []
        let idToFetch = CKRecord.Reference(recordID: activity.recordID, action: .none)

        let pred = NSPredicate(format: "activity = %@", idToFetch)
        let query = CKQuery(recordType: "ActivityOverview", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 99
        
        var fetchContent = [activityOverviewData]()
        
        operation.recordFetchedBlock = {
            record in
            let content = activityOverviewData()
            content.recordID = record.recordID
            content.forDay = record["forDay"]
            content.overviewProgress = record["progressDescription"]
            content.activity = record["activity"] as! CKRecord.Reference
            
            fetchContent.append(content)
        }
        
        operation.queryCompletionBlock = {(cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.activityOverviews = fetchContent
                } else {
                    print("Error fetching data")
                }
            }
        }
        CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.add(operation)
    }
    func loadData(){
        practiceTypeLabel.text = activity.name
        practiceLevelLabel.text = activity.level
        if activity.name == "Challenge A" {
            challengeOverviewImage.image = image[0]
        } else if activity.name == "Challenge B" {
            challengeOverviewImage.image = image[1]
        }
        pointsLabel.text = ""
        if currentUser.userEmail != nil{
            switch  currentUser.userLevel{
            case "Beginner":
                pointsLabel.text = String(currentUser.userPoints) + "/500"
                break;
            case "Medium":
                pointsLabel.text = String(currentUser.userPoints) + "/1000"
                break;
            case "Intermediate":
                pointsLabel.text = String(currentUser.userPoints) + "/2500"
                break;
            case "Advanced":
                pointsLabel.text = String(currentUser.userPoints) + "/5000"
                break;
            default:
                pointsLabel.text = String(currentUser.userPoints) + "/0"
                break
            }
            practiceLevelLabel.text = String(currentUser.userLevel)
        } else {
            switch guestStruct.guestLevel {
            case "Beginner":
                pointsLabel.text = "\(guestStruct.guestPoints)/500"
                break;
            case "Medium":
                pointsLabel.text = "\(guestStruct.guestPoints)/1000"
                break;
            case "Intermediate":
                pointsLabel.text = "\(guestStruct.guestPoints)/2500"
                break;
            case "Advanced":
                pointsLabel.text = "\(guestStruct.guestPoints)/5000"
                break;
            default:
                pointsLabel.text = "\(guestStruct.guestPoints)/0"
                break
            }
            practiceLevelLabel.text = String(guestStruct.guestLevel)
        }       
    }
    
    func updateCurrentActivity(challengeName: String, forDay: Int) {
        currentUser.currentActivityName.append(challengeName)
        currentUser.currentActivityDay.append(forDay)
        
        let pred = NSPredicate(format: "activity = %@", activity.recordID)
        let query = CKQuery(recordType: "Activity", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 99
        
        var fetchContent = activityData()
        
        
        CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.fetch(withRecordID: activity.recordID) { (record, error) in
            DispatchQueue.main.async {
                if error != nil {
                    return
                }
                
                guard let record = record else { return }
                record["currentActivityName"] = currentUser.currentActivityName as CKRecordValue
                record["currentActivityDay"] = currentUser.currentActivityDay as CKRecordValue
                
                CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.save(record) { (record, error) in
                    if error != nil {
                        return
                    }
                    guard let record = record else { return }
                    currentUser.currentActivityName = record["currentActivityName"]
                    currentUser.currentActivityDay = record["currentActivityDay"]
                }
            }
        }
    }
    
    func fetchActivityForDay(){
        var currentDay: Int = 0
        if forDay == 0 {
            currentDay = 0
        } else {
            currentDay = forDay - 1
        }
        let pred = NSPredicate(format: "recordID = %@", activityOverviews[currentDay].activity)
        let query = CKQuery(recordType: "Activity", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 99
        
        var fetchContent = activityData()
        
        operation.recordFetchedBlock = {
            record in
            let activity  = activityData()
            activity.recordID = record.recordID
            activity.name = record["name"]
            activity.topic = record["topic"]
            activity.level = record["level"]
            activity.coverImage = record["coverImage"]
            activity.totalProgress = record["totalProgress"]
            
            fetchContent = activity
        }
        
        operation.queryCompletionBlock = {(cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.activityToPass = fetchContent
                    
                    self.performSegue(withIdentifier: "segueChallengeToSpeech", sender: self.activityToPass)
                } else {
                    print("Error fetching data")
                }
            }
        }
        CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.add(operation)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SpeechShadowing = segue.destination as? SpeechShadowingViewController {
           SpeechShadowing.activity = sender as? activityData
        }

    }
    @IBAction func startTapped(_ sender: Any) {
//        if currentUser.userEmail != nil {
//            if currentUser.currentActivityName != nil {
//                for name in currentUser.currentActivityName {
//                    if (name != activity.name) {
//                        updateCurrentActivity(challengeName: activity.name, forDay: forDay)
//                    }
//                }
//            } else {
//                updateCurrentActivity(challengeName: activity.name, forDay: forDay)
//            }
//
//        } else {
//            if guestStruct.activeNames != nil {
//                for key in guestStruct.activeNames.keys {
//                    if key != activity.name {
//                        guestStruct.activeNames[activity.name] = forDay
//                    }
//                }
//            } else {
//                guestStruct.activeNames[activity.name] = forDay
//            }
//        }
        switch forDay! {
        case 0...9:
            //fetchActivitiy with activityID = content.activity
            fetchActivityForDay()
            
        case 10...20:
            performSegue(withIdentifier: "segueChallengeToSelfTalk", sender: nil)
        default:
            break
        }
    }
}

extension ChallengeOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challengeCollectionViewCell", for: indexPath) as! ChallengeCollectionViewCell        
        
        if forDay > indexPath.row {
            cell.daysView.backgroundColor = UIColor(red: 255/255, green: 157/255, blue: 80/255, alpha: 1)
            cell.daysLabel.textColor = UIColor.white
        }else {
            cell.daysView.backgroundColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
            cell.daysLabel.textColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1)
        }
        
        
        cell.daysLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dayLabel.text = "Day \(indexPath.row + 1)"
        if currentUser.userEmail != nil{
            dayDescriptionLabel.text = activityOverviews[indexPath.row].overviewProgress
        } else {
            dayDescriptionLabel.text = challengeDesc[indexPath.row]
        }
    }
    
    
}

extension ChallengeOverviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CKAsset {
    func toUIImage() -> UIImage? {
        if let data = NSData(contentsOf: self.fileURL!) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
