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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backgroundImageView.image = practiceBackgroundImage[practiceTypeId!]

        practiceDetailTableView.register(UINib(nibName: "PracticeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "practiceDetailCell")
        loadData()
        practiceDetailTableView.delegate = self
        practiceDetailTableView.dataSource = self
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
}

extension practiceDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "practiceDetailCell") as! PracticeDetailTableViewCell
        cell.selectionStyle = .none
//        cell.practiceDetailImage =
        cell.practiceTopicLabel.text = practiceTopic[indexPath.row]
        cell.practiceDetailLabel.text = practiceDetail[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
