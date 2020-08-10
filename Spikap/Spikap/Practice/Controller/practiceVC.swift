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
    let practiceImage:[UIImage] = [#imageLiteral(resourceName: "challenge card"),#imageLiteral(resourceName: "self talk card"),#imageLiteral(resourceName: "speech shadowing card")]
    var practiceTypeId:Int?
    var activityTypes: ActivityType?
    var type = [activityTypeData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        super.viewDidAppear(animated)
        setup()
        tableView.reloadData()
    }
    
    
    func setup(){
        type = []
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "ActivityType", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 99
        var newType = [activityTypeData]()
                
        operation.recordFetchedBlock = {
           record in
           let type = activityTypeData()
           type.recordID = record.recordID
           type.typeName = record["typeName"]
           type.coverImage = record["coverImage"]
            type.cardImage = record["cardImage"]
           
           for activity in record["activities"] as! [CKRecord.Reference] {
               type.activites.append(activity.recordID)
           }
           newType.append(type)
        }
               
        operation.queryCompletionBlock = { (cursor, error) in
           DispatchQueue.main.async {
               if error == nil {
                    self.type = newType
                    self.tableView.reloadData()
               } else {
                    let alert = UIAlertController(title: "Error", message: "Fetching data is unsuccessful", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
        return type.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "practiceTypeCell") as! PracticeTypeTableViewCell
        cell.selectionStyle = .none
        if let asset = type[indexPath.row].cardImage, let data = try? Data(contentsOf: asset.fileURL!), let image = UIImage(data: data) {
            cell.practiceImage.image = image
        }
//        cell.practiceImage.image = practiceImage[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.performSegue(withIdentifier: "practiceTypeSegue", sender: type[indexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
}
