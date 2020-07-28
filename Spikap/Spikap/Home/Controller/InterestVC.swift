//
//  InterestVC.swift
//  Spikap
//
//  Created by Grace Cindy on 27/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class InterestVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    var selectedInterestIndex : [Int] = []
    var selectedInterestIndex : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //change model by Interest DB here
    struct InterestModel
    {
        var interestID : Int
        var interestName: String
        var selected: Bool = false
    }
    
    //dummy Interest
    var interestList = [
        InterestModel(interestID: 1, interestName: "Animal", selected: false),
        InterestModel(interestID: 2, interestName: "Art & Design", selected: false),
        InterestModel(interestID: 3, interestName: "Cartoon", selected: false),
        InterestModel(interestID: 4, interestName: "Game", selected: false),
        InterestModel(interestID: 5, interestName: "Movies", selected: false),
        InterestModel(interestID: 6, interestName: "Music", selected: false),
        InterestModel(interestID: 7, interestName: "Sports", selected: false),
        InterestModel(interestID: 8, interestName: "Travelling", selected: false)
    ]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath)
        
        let item = interestList[indexPath.row]
        
        cell.textLabel?.text = item.interestName
        cell.accessoryType = item.selected ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //to unselect the previous selected tag
        interestList[indexPath.row].selected = !interestList[indexPath.row].selected
        
    
        if interestList[indexPath.row].selected {
            if !selectedInterestIndex.contains(indexPath.row){
                // add selected index to selectedInterestIndex
                selectedInterestIndex.append(indexPath.row)
            }
            else {
                // remove selected index from selectedInterestIndex
                selectedInterestIndex = selectedInterestIndex.filter{$0 != indexPath.row}
            }
            
        } else {
            if selectedInterestIndex.count != 0 {
//                repeatDay.remove(at: indexPath.row)
                // remove selected index from selectedInterestIndex
                selectedInterestIndex = selectedInterestIndex.filter{$0 != indexPath.row}
            }
            
        }
        
        print("selected interests array : \(selectedInterestIndex)")
        
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
