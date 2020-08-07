//
//  homeVC.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 10/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import CloudKit

class homeVC: UIViewController {
    //MARK: Variables
    
    var activitytipe: ActivityType?
    var users = [userModel]()
    var user : userModel!

    var activityType: activityTypeData!
    var activities : [Activity] = []
    var activityContent : [ActivityContent] = []
    var isUser = false

    var dayInAWeek = 7
    var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let dayYear = Calendar.current.ordinality(of: .day, in: .year, for: Date())
    let currentDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: Date())!
    
    
    //MARK: IB Outlets
    @IBOutlet weak var progressBarBackgroundView: UIView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var dayStreakCollection: UICollectionView!
    @IBOutlet weak var activitesTableView: UITableView!
    @IBOutlet weak var daysOnStreakLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var userPointLabel: UILabel!
    @IBOutlet weak var levelPointLabel: UILabel!
    @IBOutlet weak var currentActivitiesLabel: UILabel!
    @IBOutlet weak var progressBarWitdth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Points
        UserDefaults.standard.set(guestStruct.guestPoints, forKey: "guestPoints")
        guestStruct.guestPoints = UserDefaults.standard.integer(forKey: "guestPoints")
                
        // Do any additional setup after loading the view.
        configureNavigationBar(largeTitleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 0.8980392157, alpha: 1), tintColor: .white, title: "Home", preferredLargeTitle: true, fontSize: 40)
        
        activitesTableView.register(UINib(nibName: "ActivitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "activitiesCell")
        
        activitesTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        activitesTableView.delegate = self
        activitesTableView.dataSource = self
        
        UIApplication.shared.statusBarUIView?.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 0.8980392157, alpha: 1)
        progressBarSetup(CGFloat(guestStruct.guestPoints), manageLevelXP(levelName: guestStruct.guestLevel))
        
        refresh()
       
        
    }
//    var user = userModel()
    override func viewDidAppear(_ animated: Bool) {
        progressBarSetup(CGFloat(guestStruct.guestPoints), manageLevelXP(levelName: guestStruct.guestLevel))

        
        let email = KeychainItem.currentUserEmail ?? ""
        
        if email != "" {
            isUser = true
        } else {
            isUser = false
        }
        
        fetch(email: email)
//        loadHomeVC()
        print(isUser)
    }
    
    func fetch(email: String){
       
        let pred = NSPredicate(format: "userEmail = %@", email)
        let query = CKQuery(recordType: "Members", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 99
        
       
        var fetchUser = [userModel]()
        operation.recordFetchedBlock = {
           record in
           let user  = userModel()
            user.daysOnStreak =  record["daysOnStreak"]
            user.fullname =  record["firstName"]
            user.isOnStreak =  record["isOnStreak"]
            user.userPoints =  record["userPoints"]
            user.userEmail =  record["userEmail"]
            user.userLevel = record ["levelName"]
            user.isTodayDone = record["isTodayDone"]

            user.imageProfile = record["imageProfile"]


            
            fetchUser.append(user)
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                   self.users = fetchUser
                    self.loadHomeVC()
                } else {
                    print("Error fetching data")
                }
            }
        }
        CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.add(operation)
    }
    
    func loadHomeVC(){
        if isUser{

           if let asset = users[0].imageProfile, let data = try? Data(contentsOf: asset.fileURL!), let image = UIImage(data: data) {
//               cell.practiceDetailImage.image = image
            profileImageButton.setImage(image, for: .normal)
           }

            userNameLabel.text = users[0].fullname
            userPointLabel.text = String(users[0].userPoints)
            userLevelLabel.text = users[0].userLevel
            manageLevelUp(points: users[0].userPoints)
            manageLevelPoint(levelName: users[0].userLevel)
            progressBarSetup(CGFloat(users[0].userPoints), manageLevelXP(levelName: users[0].userLevel))
        }

        dayStreakCollection.reloadData()

    }
    
    
    @objc private func refresh() {
        Model.currentModel.refresh{ error in
          if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
          }
        }
        
      
        Activity.fetchActivities{ result in
            switch result {
            case .failure(let error):
              let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
              self.present(alert, animated: true, completion: nil)
            case .success(let activities):
              self.activities = activities
            }
        }
        ActivityContent.fetchActivitiesContent{ result in
            switch result {
            case .failure(let error):
              let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
              self.present(alert, animated: true, completion: nil)
            case .success(let activityContent):
              self.activityContent = activityContent
            }
        }
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        manageLevelUp(points: guestStruct.guestPoints)
        profileImageButtonSetup()
        
        userLevelLabel.text = guestStruct.guestLevel
        userPointLabel.text = String(guestStruct.guestPoints)
        
        manageLevelPoint(levelName: guestStruct.guestLevel)
        
        
        changeToSystemFont(label: daysOnStreakLabel, fontSize: 22)
        changeToSystemFont(label: userNameLabel, fontSize: 24)
        changeToSystemFont(label: currentActivitiesLabel, fontSize: 22)
    }
    
    func progressBarSetup(_ currentUserXP: CGFloat, _ levelXP: CGFloat){
        progressBarBackgroundView.layer.cornerRadius = 15
        progressBarBackgroundView.layer.borderWidth = 2.5
        progressBarBackgroundView.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        
        let viewWidth = currentUserXP / levelXP * progressBarBackgroundView.frame.width
        
        progressBarWitdth.constant = viewWidth
        progressBarView.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.31, alpha: 1.00)
        progressBarView.layer.cornerRadius = 10
        
        
        UserDefaults.standard.set(currentUserXP, forKey: "guestPoints");
    }
    
    func profileImageButtonSetup(){
        profileImageButton.frame = CGRect(x: 5, y: 5, width: 80, height: 80)
        let color = UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
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
    
    func manageLevelPoint(levelName: String){
        switch levelName {
        case "Beginner":
            levelPointLabel.text = "/500"
            break;
        case "Medium":
            levelPointLabel.text = "/1000"
            break;
        case "Intermediate":
            levelPointLabel.text = "/2500"
            break;
        case "Advanced":
            levelPointLabel.text = "/5000"
            break;
        default:
            levelPointLabel.text = "/0"
            break
        }
    }
    
    func manageLevelXP(levelName: String)->CGFloat{
        switch levelName {
        case "Beginner":
            return 500
        case "Medium":
            return 1000
        case "Intermediate":
            return 2500
        case "Advanced":
            return 5000
        default:
            return 0
        }
    }
    
    func manageLevelUp(points: Int) {
        if (points <= 500) {
            guestStruct.guestLevel = "Beginner"
        } else if (points <= 1000) {
            guestStruct.guestLevel = "Medium"
        } else if (points <= 2500) {
            guestStruct.guestLevel = "Intermediate"
        } else if (points <= 5000) {
            guestStruct.guestLevel = "Advanced"
        } else {
            guestStruct.guestLevel = "Undefined"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileDetailVC = segue.destination as? ProfileViewController {
           profileDetailVC.users = sender as? userModel
        }
    }
    
    @IBAction func ProfileDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfileDetail", sender: users[0])
    }
    
    
}

extension homeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayInAWeek
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayStreakCell", for: indexPath) as! DayStreakCollectionViewCell
        cell.streakIndicator.layer.cornerRadius = 0.5 * cell.streakIndicator.bounds.size.width
        cell.streakIndicator.layer.borderWidth = 1.5
        cell.streakIndicator.layer.borderColor = #colorLiteral(red: 0.2509803922, green: 0.7098039216, blue: 0.9529411765, alpha: 1)
        
        if isUser {
            if (users[0].isOnStreak) {
                if currentDay <= users[0].daysOnStreak {
                    if (indexPath.row < (currentDay-1)) {
                        cell.streakIndicator.layer.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.7098039216, blue: 0.9529411765, alpha: 1)
                    }
                } else if currentDay > users[0].daysOnStreak {
                    if (indexPath.row >= (currentDay - guestStruct.daysOnStreak - 1) && indexPath.row < currentDay-1) {
                        cell.streakIndicator.layer.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.7098039216, blue: 0.9529411765, alpha: 1)
                    }
                }
                
                if (users[0].isTodayDone) {
                    if(indexPath.row == (currentDay-1)) {
                        cell.streakIndicator.layer.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.7098039216, blue: 0.9529411765, alpha: 1)
                    }
                } else {
                    if(indexPath.row == (currentDay-1)) {
                        cell.streakIndicator.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    }
                }
            }
        } else {
            if (guestStruct.isOnStreak) {
                if currentDay <= guestStruct.daysOnStreak {
                    if (indexPath.row < (currentDay-1)) {
                        cell.streakIndicator.layer.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.7098039216, blue: 0.9529411765, alpha: 1)
                    }
                } else if currentDay > guestStruct.daysOnStreak {
                    if (indexPath.row >= (currentDay - guestStruct.daysOnStreak - 1) && indexPath.row < currentDay-1) {
                        cell.streakIndicator.layer.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.7098039216, blue: 0.9529411765, alpha: 1)
                    }
                }
                
                if (guestStruct.isTodayDone) {
                    if(indexPath.row == (currentDay-1)) {
                        cell.streakIndicator.layer.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.7098039216, blue: 0.9529411765, alpha: 1)
                    }
                } else {
                    if(indexPath.row == (currentDay-1)) {
                        cell.streakIndicator.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    }
                }
            }
        }
        
        cell.dayName.text = days[indexPath.row]
        
        return cell
    }
}

extension homeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activitiesCell") as! ActivitiesTableViewCell
        cell.selectionStyle = .none
//        cell.activitiesImageView.image =
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
}
