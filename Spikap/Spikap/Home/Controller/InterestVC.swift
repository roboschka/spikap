//
//  InterestVC.swift
//  Spikap
//
//  Created by Grace Cindy on 27/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class InterestVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var interestTableView: UITableView!
    
    var userInterestList : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.interestTableView.delegate = self
        self.interestTableView.dataSource = self
        self.navigationController?.delegate = self
        
        print("initial interest list : \( getUserInterest() )")
    }
    
    
    //change model by Interest DB here
    struct InterestModel
    {
        var interestID : Int
        var interestName: String
        var selectedFlag: Bool = false
    }
    
    //default Interest list
    let interestList = [
        InterestModel(interestID: 1, interestName: "Animal"),
        InterestModel(interestID: 2, interestName: "Art & Design"),
        InterestModel(interestID: 3, interestName: "Cartoon"),
        InterestModel(interestID: 4, interestName: "Game"),
        InterestModel(interestID: 5, interestName: "Movies"),
        InterestModel(interestID: 6, interestName: "Music"),
        InterestModel(interestID: 7, interestName: "Sports"),
        InterestModel(interestID: 8, interestName: "Travelling")
    ]
    
    func getUserInterest() ->[Int]
    {
        //dummy data, replace from DB
        userInterestList = [1, 2, 3, 4]
        return userInterestList
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath)
        
        let item = interestList[indexPath.row]
        
        cell.textLabel?.text = item.interestName
        if userInterestList.contains(item.interestID)
        {
            cell.isSelected = true
            cell.accessoryType = .checkmark
        }
        else{
            cell.isSelected = false
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = interestList[indexPath.row]
        if userInterestList.contains(item.interestID)
        {
            userInterestList.removeAll{ $0 == item.interestID}
        }
        else
        {
            userInterestList.append(item.interestID)
        }
        
        print("selected interestID array : \(userInterestList)")
        
        tableView.reloadData()
        
    }
    

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
