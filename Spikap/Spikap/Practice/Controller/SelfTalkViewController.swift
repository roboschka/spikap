//
//  SelfTalkViewController.swift
//  Spikap
//
//  Created by Muhammad Rivan Rayhan on 26/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import AVFoundation

class SelfTalkViewController: UIViewController {

    var topic = "Travelling"
    var totalProgress = 8
    var currentProgress = 0
    let synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var progressBarView: UICollectionView!
    @IBOutlet weak var firstReplyView: UIView!
    @IBOutlet weak var secondReplyView: UIView!
    @IBOutlet weak var firstCardLabel: UILabel!
    @IBOutlet weak var secondCardLabel: UILabel!
    @IBOutlet weak var chatBotImage: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var speechView: UIView!
    @IBOutlet weak var chatBotView: UIView!
    @IBOutlet weak var chatBotLabel: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userReplyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeToSystemFont(label: topicLabel, fontSize: 20)
        
        topicLabel.text = topic
    }
    
    func setUpView(){
        firstReplyView.layer.borderColor = UIColor.gray.cgColor
        firstReplyView.layer.borderWidth = 1
        firstReplyView.layer.cornerRadius = 15
        secondReplyView.layer.borderColor = UIColor.gray.cgColor
        secondReplyView.layer.borderWidth = 1
        secondReplyView.layer.cornerRadius = 15
        chatBotView.layer.cornerRadius = 15
    }
    @IBAction func goBack(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to go back?", message: "You will loose your progress by going back", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go Back", style: .default, handler: { action in
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    @IBAction func firstVoiceTapped(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: firstCardLabel.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-BG")
        utterance.rate = 0.4

        synthesizer.speak(utterance)
    }
    
    @IBAction func secondVoiceTapped(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: secondCardLabel.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-BG")
        utterance.rate = 0.4

        synthesizer.speak(utterance)
    }
}

extension SelfTalkViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var bounds: CGSize = CGSize.zero
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.bounds.width {
            case 750:
                bounds = CGSize(width: 10, height: 5)
            default:
                bounds =  CGSize(width: 40, height: 8)
            }
            
        } else if UIDevice().userInterfaceIdiom == .pad {
            if (UIDevice.current.userInterfaceIdiom == .pad && (UIScreen.main.bounds.size.height == 834 || UIScreen.main.bounds.size.height == 1194)) {
                bounds = CGSize(width: 90, height: 12)
            } else {
                print(UIScreen.main.bounds.size)
            }
        }
        return bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PracticeProgressCell", for: indexPath) as! PracticeProgressCollectionViewCell
        cell.practiceBar.layer.cornerRadius = 0.1 * cell.practiceBar.bounds.height
        
        if (indexPath.row <= (currentProgress-1)) {
            cell.practiceBar.layer.backgroundColor = #colorLiteral(red: 0.3921568627, green: 0.8235294118, blue: 1, alpha: 1)
        } else {
            cell.practiceBar.layer.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
        }
        
        return cell;
    }
    
}
