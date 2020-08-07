//
//  practiceVC.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 10/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import CloudKit


class practiceVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let practiceImage:[UIImage] = [#imageLiteral(resourceName: "21 days challenge card"),#imageLiteral(resourceName: "self talk card"),#imageLiteral(resourceName: "pdf speech shadow")]
    var practiceTypeId:Int?
    var activityTypes: ActivityType?
    var type = [activityTypeData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setup()
        tableView.register(UINib(nibName: "PracticeTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "practiceTypeCell")
        // Do any additional setup after loading the view.
        configureNavigationBar(largeTitleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 0.8980392157, alpha: 1), tintColor: .white, title: "Practice", preferredLargeTitle: true, fontSize: 40)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        UIApplication.shared.statusBarUIView?.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 0.8980392157, alpha: 1)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//       setup()
    }
    
    
    func setup(){
        let pred = NSPredicate(value: true)
               let query = CKQuery(recordType: "ActivityType", predicate: pred)
               let operation = CKQueryOperation(query: query)
               var newType = [activityTypeData]()
               operation.recordFetchedBlock = {
                   record in
                   let type = activityTypeData()
                   type.recordID = record.recordID
                   type.typeName = record["typeName"]
                   type.coverImage = record["coverImage"]
                   
                   for activity in record["activities"] as! [CKRecord.Reference] {
                       type.activites.append(activity.recordID)
                   }
                   newType.append(type)
               }
               
               operation.queryCompletionBlock = { [unowned self] (cursor, error) in
                   DispatchQueue.main.async {
                       if error == nil {
                           self.type = newType
                       } else {
                           print("Error fetching data")
                       }
                   }
               }
               
               CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.add(operation)
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
           practiceDetailVC.activityType = sender as? activityTypeData
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
        cell.layer.cornerRadius = 15
        cell.practiceImage.image = practiceImage[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.performSegue(withIdentifier: "practiceTypeSegue", sender: type[indexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
}
