//
//  homeVC.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 10/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class homeVC: UIViewController {
    //MARK: Variables
    var dayInAWeek = 7
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    //MARK: IB Outlets
    @IBOutlet weak var progressBarBackgroundView: UIView!
    @IBOutlet weak var dayStreakCollection: UICollectionView!
    @IBOutlet weak var daysOnStreakLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureNavigationBar(largeTitleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 0.8980392157, alpha: 1), tintColor: .white, title: "Home", preferredLargeTitle: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileImageButtonSetup()
        progressBarSetup(100, 500)
        changeToSystemFont(label: daysOnStreakLabel, fontSize: 24)
        changeToSystemFont(label: userNameLabel, fontSize: 24)
    }
    func progressBarSetup(_ currentUserXP: CGFloat, _ levelXP: CGFloat){
        progressBarBackgroundView.layer.cornerRadius = 15
        progressBarBackgroundView.layer.borderWidth = 2.5
        progressBarBackgroundView.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        
        let progressView = UIView()
        let viewWidth = currentUserXP / levelXP * progressBarBackgroundView.bounds.size.width
        
        progressView.center = CGPoint(x: 5 , y:  4.5)
        progressView.layer.frame.size = CGSize(width: viewWidth, height: 0.7 * progressBarBackgroundView.bounds.size.height)
        progressView.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.31, alpha: 1.00)
        progressView.layer.cornerRadius = 10
        
        progressBarBackgroundView.addSubview(progressView)
        
    }
    func profileImageButtonSetup(){
        profileImageButton.frame = CGRect(x: 5, y: 5, width: 80, height: 80)
        let color = UIColor(cgColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        profileImageButton.backgroundColor = color
        profileImageButton.layer.cornerRadius = 0.5 * profileImageButton.bounds.size.width
    }
    func profileBarButtonItem(){
        let profileButton = UIButton(type: .custom)
        profileButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let color = UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        profileButton.backgroundColor = color
        profileButton.layer.cornerRadius = 0.5 * profileButton.bounds.size.width
        
        let barButton = UIBarButtonItem()
        barButton.customView = profileButton
        self.navigationItem.rightBarButtonItem = barButton
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

extension homeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayInAWeek
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayStreakCell", for: indexPath) as! DayStreakCollectionViewCell
        cell.streakIndicator.layer.cornerRadius = 0.5 * cell.streakIndicator.bounds.size.width
        cell.streakIndicator.layer.borderWidth = 1.5
        cell.streakIndicator.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        cell.dayName.text = days[indexPath.row]
        
        return cell
    }
}
