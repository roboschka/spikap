//
//  SpeechShadowingViewController.swift
//  Spikap
//
//  Created by Maria Jeffina on 22/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechShadowingViewController: UIViewController, AVAudioRecorderDelegate {
    //MARK: Variables
    var topic = "Travelling"
    var totalProgress = 8
    var currentProgress = 0
    
    var contents = ["Travel", "Backpack", "Map", "Roadtrip", "Wanderlust", "Van", "Recreation", "Compass"]
    var contentsToken = [["Tra", "vel"], ["Back", "pack"], ["Map"], ["Road", "trip"], ["Wan", "der", "lust"], ["Van"], ["Re", "crea", "tion"], ["Com", "pass"]]
    var info = ["This is the definition of the word. Please do write some long sentences just to test out auto layout"]
    var result = true
    
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    //MARK: IB Outlet
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var contentInfoLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var progressBarView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNextButton()
        setupTokenLabel(progress: currentProgress)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        changeToSystemFont(label: topicLabel, fontSize: 20)
        
        topicLabel.text = topic
        questionLabel.text = contents[0]
        
        contentInfoLabel.text = info[0]
    }
    
    //MARK: IB Actions
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
    
    @IBAction func recordVoice(_ sender: Any) {
        recordPermission()
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            print("tap to stop")
        } catch {
            finishRecording(success: false)
        }
    }
    
    @IBAction func nextProgressButton(_ sender: Any) {
        weak var pvc = self.presentingViewController
        currentProgress += 1
        if(currentProgress > totalProgress - 1) {
            performSegue(withIdentifier: "toCongratulations", sender: nil)
        } else {
            questionLabel.text = contents[currentProgress]
            setupTokenLabel(progress: currentProgress)
            progressBarView.reloadData()
        }
        
    }
    
    
    
    //MARK: Functions
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            print("tap to re-record")
        } else {
            print("tap to record")
            // recording failed :(
        }
    }
    func recordPermission(){
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordVoice(self)
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func setupNextButton(){
        nextButton.imageView?.contentMode = .scaleAspectFit
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        nextButton.layer.isHidden = false
    }
    
    func setupTokenLabel(progress: Int){
        var finalString: String = ""
        for index in 0 ..< contentsToken[progress].count {
            let value = contentsToken[progress][index]
           
            if index == contentsToken[progress].count - 1 {
                finalString = finalString + value
            } else {
                finalString = finalString + value + " - "
            }
        }
        tokenLabel.text = finalString
    }

}

extension SpeechShadowingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
