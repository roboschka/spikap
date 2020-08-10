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
    var activity: activityData!
    var activityOverviews = [activityOverviewData]()
    
    var practiceId:Int?
    var challengeDesc:[String] = ["Practice your pronunciation using Vacation topic in speech shadowing","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your pronunciation using Vacation topic in speech shadowing","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your pronunciation using Vacation topic in speech shadowing","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your speaking skills using Travelling topic in self-talk","Practice your speaking skills using Job Interview topic in self-talk","Practice your speaking skills using Ordering food topic in self-talk","Practice your speaking skills using Travelling topic in self-talk","Practice your speaking skills using Job Interview topic in self-talk","Practice your speaking skills using Ordering food topic in self-talk","Practice your speaking skills using Travelling topic in self-talk","Practice your speaking skills using Job Interview topic in self-talk","Practice your speaking skills using Ordering food topic in self-talk","Go to community and post any topic you like","Go to community and post any topic you like","Go to community and post any topic you like"]
    var forDay:Int = 5
    
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
        switch practiceId {
        case 0:
            practiceTypeLabel.text = "Challenge A"
            practiceLevelLabel.text = "Beginner"
            challengeOverviewImage.image = #imageLiteral(resourceName: "challenge a background")
        case 1:
            practiceTypeLabel.text = "Challenge B"
            practiceLevelLabel.text = "Intermediate"
            challengeOverviewImage.image = #imageLiteral(resourceName: "challenge a background")
        case 2:
            practiceTypeLabel.text = "Challenge C"
            practiceLevelLabel.text = "Advanced"
            challengeOverviewImage.image = #imageLiteral(resourceName: "challenge a background")
        default:
            break
        }
        dayDescriptionLabel.text = "Practice your pronunciation using Vacation topic in speech shadowing"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    @IBAction func startTapped(_ sender: Any) {
        switch forDay {
        case 0...8:
            performSegue(withIdentifier: "segueChallengeToSpeech", sender: nil)
        case 9...17:
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
        dayDescriptionLabel.text = activityOverviews[indexPath.row].overviewProgress
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
