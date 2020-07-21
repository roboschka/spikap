//
//  practiceVC.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 10/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class practiceVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let practiceImage:[UIImage] = [#imageLiteral(resourceName: "21 days challenge card"),#imageLiteral(resourceName: "self talk card"),#imageLiteral(resourceName: "speech shadowing card")]
    var practiceTypeId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PracticeTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "practiceTypeCell")
        // Do any additional setup after loading the view.
//        configureNavigationBar(largeTitleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 0.8980392157, alpha: 1), tintColor: .white, title: "Practice", preferredLargeTitle: true)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let practiceDetailVC = segue.destination as? practiceDetailVC {
            practiceDetailVC.practiceTypeId = sender as? Int
        }
    }
}

extension practiceVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "practiceTypeCell") as! PracticeTypeTableViewCell
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 20
        cell.practiceImage.image = practiceImage[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "practiceTypeSegue", sender: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
}
