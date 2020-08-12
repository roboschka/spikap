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
    
    var activityContent : [ActivityContent] = []
    var currentActivity = [activityData]()
    var isUser = false
    
    var value:Int?
    
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
    @IBOutlet weak var progressBarTrailingSpace: NSLayoutConstraint!
    
    
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
        
//        refresh()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let email = KeychainItem.currentUserEmail ?? ""
        let fullname = KeychainItem.currentUserGivenName ?? ""
        if email != "" {
            isUser = true
            fetchUser(email: email, fullname: fullname)
        } else {
            isUser = false
            fetchCurrentActivities(activeID: Array(guestStruct.activeNames.keys))
        }
        
        progressBarSetup(CGFloat(guestStruct.guestPoints), manageLevelXP(levelName: guestStruct.guestLevel))
        
        print(isUser)
    }
    
    func fetchUser(email: String, fullname: String) {
        let pred = NSPredicate(format: "userEmail = %@", email)
        let query = CKQuery(recordType: "Members", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 99
       
        var fetchUser = [userModel]()
        var fetchUser2 = userModel()
        
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
            user.currentActivityDay = record["currentActivityDay"]
            user.currentActivityName = record["currentActivityName"]
            
            fetchUser.append(user)
            fetchUser2 = user
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {

                    if fetchUser.count == 0 {
                        Userextention.createUser(fullName: fullname , userEmail: email)
                        self.fetchUser(email: email, fullname: fullname)
                    } else {
                        self.users = fetchUser
                        currentUser = fetchUser2
                        self.loadHomeVC()
                    }
                     

                } else {
                    print("Error fetching data")
                }
            }
        }
        CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.add(operation)
    }
    
    func fetchCurrentActivities(activeID: [String]) {
        let pred = NSPredicate(format: "name IN %@", activeID)
        let query = CKQuery(recordType: "Activity", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        
        var fetchActivity = [activityData]()
        operation.recordFetchedBlock = {
            record in
            let activity = activityData()
            activity.recordID = record.recordID
            activity.continueImage = record["continueImage"]
            activity.name = record["name"]
            
            fetchActivity.append(activity)
        }
        
        operation.queryCompletionBlock = {(cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.currentActivity = fetchActivity
                    self.activitesTableView.reloadData()
                }
            }
        }
        
        CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.add(operation)
    }
    
    func loadHomeVC(){
        if isUser{

           if let asset = users[0].imageProfile, let data = try? Data(contentsOf: asset.fileURL!), let image = UIImage(data: data) {
            profileImageButton.setImage(image, for: .normal)
            profileImageButton.imageView?.layer.cornerRadius = 0.5 * profileImageButton.bounds.size.width
           }

            userNameLabel.text = users[0].fullname
            userPointLabel.text = String(users[0].userPoints)
            userLevelLabel.text = users[0].userLevel
            manageLevelUp(points: users[0].userPoints)
            manageLevelPoint(levelName: users[0].userLevel)
            progressBarSetup(CGFloat(users[0].userPoints), manageLevelXP(levelName: users[0].userLevel))
            
            for (index, name) in currentUser.currentActivityName.enumerated() {
                currentUser.activeNames[name] = currentUser.currentActivityDay[index]
            }
            fetchCurrentActivities(activeID: Array(currentUser.activeNames.keys))
        }
        dayStreakCollection.reloadData()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        manageLevelUp(points: guestStruct.guestPoints)
        profileImageButtonSetup()
        
        userLevelLabel.text = guestStruct.guestLevel
        userPointLabel.text = String(guestStruct.guestPoints)
        
        manageLevelPoint(levelName: guestStruct.guestLevel)
        
        changeToSystemFont(label: daysOnStreakLabel, fontSize: userNameLabel.font.pointSize)
        changeToSystemFont(label: userNameLabel, fontSize: userNameLabel.font.pointSize)
        changeToSystemFont(label: currentActivitiesLabel, fontSize: currentActivitiesLabel.font.pointSize)
    }
    
    func progressBarSetup(_ currentUserXP: CGFloat, _ levelXP: CGFloat){
        progressBarBackgroundView.layer.cornerRadius = 15
        progressBarBackgroundView.layer.borderWidth = 2.5
        progressBarBackgroundView.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        
        //trailing space based on size class
        let viewWidth = (currentUserXP / levelXP * progressBarBackgroundView.frame.width) - progressBarTrailingSpace.constant
        
        progressBarView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        
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
        }else if let challengeOverviewVC = segue.destination as? ChallengeOverviewViewController {
            challengeOverviewVC.activity = sender as? activityData
            challengeOverviewVC.forDay = value!
        }
    }
    
    @IBAction func ProfileDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfileDetail", sender: users[0])
    }
    
    
}

extension homeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayInAWeek
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var bounds: CGSize = CGSize.zero
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.bounds.width {
            case 750:
                bounds = CGSize(width: 44, height: 61)
            default:
                bounds =  CGSize(width: 46, height: 61)
            }
            
        } else if UIDevice().userInterfaceIdiom == .pad {
            if (UIDevice.current.userInterfaceIdiom == .pad && (UIScreen.main.bounds.size.height == 834 || UIScreen.main.bounds.size.height == 1194)) {
                bounds = CGSize(width: 90, height: 110)
            } else {
                print(UIScreen.main.bounds.size)
            }
        }
        return bounds
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
        return currentActivity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activitiesCell") as! ActivitiesTableViewCell
        cell.selectionStyle = .none
        if let asset = currentActivity[indexPath.row].continueImage,
           let data = try? Data(contentsOf: asset.fileURL!),
           let image = UIImage(data: data) {
            cell.activitiesImageView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isUser {
            let keyToGet = Array(currentUser.activeNames.keys)[indexPath.row]
            value = currentUser.activeNames[keyToGet]!
            print(currentActivity[indexPath.row].name)
            print(value)
        } else {
            let keyToGet = Array(guestStruct.activeNames.keys)[indexPath.row]
            value = guestStruct.activeNames[keyToGet]!
            print(currentActivity[indexPath.row].name)
            print(value)
        }
        //Data untuk performSegue activity to ChallengeOverview
        self.performSegue(withIdentifier: "segueToChallengeOverview", sender: currentActivity[indexPath.row])

    }
}
