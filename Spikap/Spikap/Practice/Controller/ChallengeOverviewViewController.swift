//
//  ChallengeOverviewViewController.swift
//  Spikap
//
//  Created by Muhammad Rivan Rayhan on 23/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class ChallengeOverviewViewController: UIViewController {

    
    @IBOutlet weak var challengeOverviewImage: UIImageView!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var dayDescriptionLabel: UILabel!
    @IBOutlet weak var practiceTypeLabel: UILabel!
    @IBOutlet weak var practiceLevelLabel: UILabel!
    
    var practiceId:Int?
    var challengeDesc:[String] = ["Practice your pronunciation using Vacation topic in speech shadowing","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your pronunciation using Vacation topic in speech shadowing","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your pronunciation using Vacation topic in speech shadowing","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your speaking skills using Travelling topic in self-talk","Practice your speaking skills using Job Interview topic in self-talk","Practice your speaking skills using Ordering food topic in self-talk","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your speaking skills using Travelling topic in self-talk","Practice your speaking skills using Job Interview topic in self-talk","Practice your speaking skills using Ordering food topic in self-talk","Practice your pronunciation using Sport topic in speech shadowing","Practice your pronunciation using Culture topic in speech shadowing","Practice your speaking skills using Travelling topic in self-talk","Practice your speaking skills using Job Interview topic in self-talk","Practice your speaking skills using Ordering food topic in self-talk","Go to community and post any topic you like","Go to community and comment if some of the post","Go to community and post any topic you like"]
    
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
}

extension ChallengeOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challengeCollectionViewCell", for: indexPath) as! ChallengeCollectionViewCell        
        
        cell.daysLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dayLabel.text = "Day \(indexPath.row + 1)"
        dayDescriptionLabel.text = challengeDesc[indexPath.row]
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
