//
//  practiceDetailVC.swift
//  Spikap
//
//  Created by Muhammad Rivan Rayhan on 21/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class practiceDetailVC: UIViewController {
    
    @IBOutlet weak var practiceDetailTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var practiceTypeId:Int?
    let practiceBackgroundImage:[UIImage] = [#imageLiteral(resourceName: "challenge background"),#imageLiteral(resourceName: "self talk background"),#imageLiteral(resourceName: "speech shadowing background")]
    var practiceDetail:[String] = []
    var practiceTopic:[String] = []
    var practiceImage:[UIImage] = [#imageLiteral(resourceName: "challenge a"),#imageLiteral(resourceName: "challenge b"),#imageLiteral(resourceName: "challenge c")]
    var practiceId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backgroundImageView.image = practiceBackgroundImage[practiceTypeId!]

        practiceDetailTableView.register(UINib(nibName: "PracticeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "practiceDetailCell")
        loadData()
        practiceDetailTableView.delegate = self
        practiceDetailTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //load data sementara
    func loadData(){
        switch practiceTypeId {
        case 0:
            practiceDetail = ["Challenge A","Challenge B","Challenge C"]
            practiceTopic = ["Beginner","Intermediate","Advanced"]
        case 1:
            practiceDetail = ["Practice A","Practice B","Practice C"]
            practiceTopic = ["Travelling","Job Interview","Ordering Food"]
        case 2:
            practiceDetail = ["Practice A","Practice B","Practice C"]
            practiceTopic = ["Vacation","Sport","Culture"]
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let challengeVC = segue.destination as? ChallengeOverviewViewController {
            challengeVC.practiceId = sender as? Int
        }
    }
}

extension practiceDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "practiceDetailCell") as! PracticeDetailTableViewCell
        cell.selectionStyle = .none
        cell.practiceDetailImage.image = practiceImage[indexPath.row]
        cell.practiceTopicLabel.text = practiceTopic[indexPath.row]
        cell.practiceDetailLabel.text = practiceDetail[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch practiceTypeId {
        case 0:
            performSegue(withIdentifier: "segueToChallengeOverview", sender: indexPath.row)
        case 1:
            performSegue(withIdentifier: "segueToSelfTalk", sender: nil)
        case 2:
            performSegue(withIdentifier: "segueToSpeechShadowing", sender: nil)
        default:
            return
        }
    }
}
