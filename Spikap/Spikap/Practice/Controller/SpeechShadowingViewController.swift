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
    
    let audioEngine = AVAudioEngine()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var inputFormat: AVAudioFormat!
    var audioFileName: URL!
    
    let player = AVQueuePlayer()
    
    var isRecording: Bool = false
    
    //MARK: IB Outlet
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var contentInfoLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var progressBarView: UICollectionView!
    @IBOutlet weak var playAudioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        setupNextButton()
        setupTokenLabel(progress: currentProgress)
        recordPermission()
        playAudioButton.isEnabled = true
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
    
    
    @IBAction func nextProgressButton(_ sender: Any) {
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
    
    func loadRecordingUI() {
        print("Tap to record")
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
            playAudioButton.isEnabled = false
        } else {
            finishRecording(success: true)
            playAudioButton.isEnabled = true
        }
    }
    
    func startRecording() {
        audioFileName = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        recordButton.setImage(#imageLiteral(resourceName: "play audio"), for: .normal)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            do {
                try audioEngine.start()
            } catch ( _) {
                print("error in starting audio engine")
            }
            print("Tap to stop")
        } catch {
            finishRecording(success: false)
        }
    }
    
    
    func finishRecording(success: Bool) {
        recordButton.setImage(#imageLiteral(resourceName: "mic button"), for: .normal)
        audioEngine.stop()
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("tap to re-record")
            print(audioFileName.absoluteString)
        } else {
            print("tap to record")
        }
    }
    
    func recordPermission(){
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true, options: [])
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
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
