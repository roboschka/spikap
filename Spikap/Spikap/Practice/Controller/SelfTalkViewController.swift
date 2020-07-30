//
//  SelfTalkViewController.swift
//  Spikap
//
//  Created by Muhammad Rivan Rayhan on 26/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class SelfTalkViewController: UIViewController, SFSpeechRecognizerDelegate, AVAudioRecorderDelegate{

    var topic = "Travelling"
    var totalProgress = 8
    var currentProgress = 0
    var result: String = ""
    
    var question = ["Where did you go on holiday?","How was it? Did you have a good time?","What did you do there?","How long did you stay?","I have been to beijing once to attend a conference, but I did'nt have time to travel around.","Really? Where did you stay anyway?","Was it good?","I didn't go out because I took a charity job as volunteer tutor."]
    var firstAnswer = ["I went to Beijing with my family","Yes, Beijing was wonderful","We went to the Great Wall and other interesting places","We stayed for about seven days","Too bad. You could have stayed longer. It's not difficult to find cheap hotels in Beijing","We stayed at the Orange Hotel near the Palace Museum.","Yes, it was a great budget hotel and it offered free snacks everyday. How about your holiday?","Oh, that's good. I may want to try that on my next holiday."]
    var secondAnswer = ["I went to Beijing last holiday","Yes, Beijing is an awesome city","I went to see some pandas, they are amusing","We stayed for around one week","What a pity. You should have stayed longer. I'm sure it's easy to find cheap hotels in Beijing","At the Orange Hotel. It's nearer to tourist spot", "Yes, the room was clean and it offered free drinks everyday. How about your holiday?","That's great I may want to try that too"]
    
    let synthesizer = AVSpeechSynthesizer()
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var inputFormat: AVAudioFormat!
    var audioFileName: URL!
    
    var isRecording: Bool = false
    var confidenceCheck : [Float] = []
    
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
    @IBOutlet weak var secondVoiceButton: UIButton!
    @IBOutlet weak var firstVoiceButton: UIButton!
    @IBOutlet weak var chatBotVoice: UIButton!
    @IBOutlet weak var userReplyVoice: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeToSystemFont(label: topicLabel, fontSize: 20)
        
        topicLabel.text = topic
        firstCardLabel.text = firstAnswer[0]
        secondCardLabel.text = secondAnswer[0]
        chatBotLabel.text = question[0]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
                   OperationQueue.main.addOperation {
                       switch authStatus {
                           case .authorized:
                               self.recordButton.isEnabled = true
        
                           case .denied:
                               self.recordButton.isEnabled = false
                               self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
        
                           case .restricted:
                               self.recordButton.isEnabled = false
                               self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
        
                           case .notDetermined:
                               self.recordButton.isEnabled = false
                               self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                       }
                   }
               }
    }
    
    func setUpView(){
        firstReplyView.layer.borderColor = UIColor.gray.cgColor
        firstReplyView.layer.borderWidth = 1
        firstReplyView.layer.cornerRadius = 15
        secondReplyView.layer.borderColor = UIColor.gray.cgColor
        secondReplyView.layer.borderWidth = 1
        secondReplyView.layer.cornerRadius = 15
        chatBotView.layer.cornerRadius = 15
        chatBotImage.image = UIImage(named: "mascot")
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
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
//            playAudioButton.isEnabled = true
            recordButton.setImage(#imageLiteral(resourceName: "mic button"), for: .normal)
            checkPronounciationResult(result, firstAnswer[currentProgress], secondAnswer[currentProgress])
            
        } else {
            try! startRecording()
            userReplyLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            userReplyLabel.text = "..."
            recordButton.setImage(#imageLiteral(resourceName: "record button"), for: .normal)
            userReplyLabel.textAlignment = .center
        }
    }
    
    func colorString(_ main: String,_ string: String, _ color: UIColor,_ label: UILabel){
        let range = (main as NSString).range(of: string)
        let attribute = NSMutableAttributedString.init(string: main)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        label.attributedText = attribute
    }
    
    func checkPronounciationResult(_ result: String,_ firstReply: String,_ secondReply: String){
        userReplyLabel.textAlignment = .left
        
            if (confidenceCheck.count == result.words.count) {
                //Hasil SpeechToText sesuai sama result, gak ada yang satu segment dua kata gitu
                if result.words.count == firstReply.words.count {
                    //Jumlah kata dalam jawaban user = jumlah kata dalam jawaban pertama
                    let attribute = NSMutableAttributedString.init(string: result)
                    
                    for (index, substring) in result.words.enumerated() {
                        print(confidenceCheck[index])
                        print(result.words[index])
                        if substring.uppercased() == firstReply.uppercased().words[index] {
                            //Kata di result = kata index x di jawaban pertama
                            //Check confidence
                            if confidenceCheck[index] == 0 {
                                print("Good: \(substring)")
                                let range = (result as NSString).range(of: String(substring))
                                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(cgColor: #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)), range: range)
                                speechView.isHidden = true
                                correctSound()
                            } else if confidenceCheck[index] >= 0.7 {
                                print("OK: \(substring)")
                                colorString(result, String(substring), UIColor.green, userReplyLabel)
                                let range = (result as NSString).range(of: String(substring))
                                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(cgColor: #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)), range: range)
                                speechView.isHidden = true
                                correctSound()
                            } else {
                                print("Poor: \(substring)")
                                colorString(result, String(substring), UIColor.yellow, userReplyLabel)
                                let range = (result as NSString).range(of: String(substring))
                                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(cgColor: #colorLiteral(red: 1, green: 0.5675869372, blue: 0.2278224571, alpha: 1)), range: range)
                                wrongSound()
                            }
                        } else {
                            //"WANT" === "WENT"
                            //Kata tidak sesuai/sama dengan yang ada di jawaban 1 / 2
                            print("You got this wrong: \(substring)")
                            let range = (result as NSString).range(of: String(substring))
                            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(cgColor: #colorLiteral(red: 0.8078431373, green: 0.02745098039, blue: 0.3333333333, alpha: 1)), range: range)
                            wrongSound()
                        }
                    }
                    userReplyLabel.attributedText = attribute
                } else if (result.words.count == secondReply.words.count) {
                    //Jumlah kata dalam jawaban user = jumlah kata dalam jawaban kedua
                    let attribute = NSMutableAttributedString.init(string: result)
                    for (index, substring) in result.words.enumerated() {
                        print(confidenceCheck[index])
                        print(result.words[index])
                        
                        if substring.uppercased() == secondReply.uppercased().words[index] {
                            //Kata di result = kata index x di jawaban pertama
                            //Check confidence
                            if confidenceCheck[index] == 0 {
                                print("Good: \(substring)")
                                let range = (result as NSString).range(of: String(substring))
                                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(cgColor: #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)), range: range)
                                speechView.isHidden = true
                                correctSound()
                            } else if confidenceCheck[index] >= 0.7 {
                                print("OK: \(substring)")
                                let range = (result as NSString).range(of: String(substring))
                                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(cgColor: #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)), range: range)
                                speechView.isHidden = true
                                correctSound()
                            } else {
                                print("Poor: \(substring)")
                                let range = (result as NSString).range(of: String(substring))
                                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(cgColor: #colorLiteral(red: 1, green: 0.5675869372, blue: 0.2278224571, alpha: 1)), range: range)
                                wrongSound()
                            }
                        } else {
                            //"WANT" === "WENT"
                            //Kata tidak sesuai/sama dengan yang ada di jawaban 1 / 2
                            print("You got this wrong: \(substring)")
                            let range = (result as NSString).range(of: String(substring))
                            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(cgColor: #colorLiteral(red: 0.8078431373, green: 0.02745098039, blue: 0.3333333333, alpha: 1)), range: range)
                            wrongSound()
                        }
                    }
                    userReplyLabel.attributedText = attribute
                } else {
                    //Jumlah kata dalam jawaban user != jumlah kata dalam jawaban pertama/kedua
                    userReplyLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    print(firstReply.uppercased().words)
                    print(secondReply.uppercased().words)
                    print(result.uppercased().words)
                    wrongSound()
                }
                
            } else {
                //Kata di speechRecognition ada yang ke concat (1 segment lebih dari 1 kata)
                if (result.uppercased().words == firstReply.uppercased().words) {
                    userReplyLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)
                    speechView.isHidden = true
                    correctSound()
                } else if(result.uppercased().words == secondReply.uppercased().words){
                    userReplyLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)
                    speechView.isHidden = true
                    correctSound()
                } else {
                    userReplyLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    print(firstReply.uppercased().words)
                    print(secondReply.uppercased().words)
                    print(result.uppercased().words)
                    wrongSound()
                }
            }
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        currentProgress += 1
        if(currentProgress > totalProgress - 1) {
            performSegue(withIdentifier: "toCongratulations", sender: nil)
        } else {
            firstCardLabel.text = firstAnswer[currentProgress]
            secondCardLabel.text = secondAnswer[currentProgress]
            chatBotLabel.text = question[currentProgress]
            progressBarView.reloadData()
            speechView.isHidden = false
            userReplyLabel.text = "..."
            userReplyLabel.textAlignment = .center
        }
    }
    
    @IBAction func voiceButtonTapped(_ sender: UIButton) {
        var string = ""
        if sender == firstVoiceButton {
            string = firstCardLabel.text!
        }else if sender == secondVoiceButton {
            string = secondCardLabel.text!
        }else if sender == chatBotVoice {
            string = chatBotLabel.text!
        }else if sender == userReplyVoice{
            
        }
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
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

extension SelfTalkViewController {
    private func startRecording() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record)
        try audioSession.setMode(.measurement)
        
        try audioSession.setActive(true, options: .init())
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let node = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try! audioEngine.start()
        confidenceCheck = []
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) {
            result, error in
            guard let result = result else { return }
            
            
            if result.isFinal {
                print(result.bestTranscription.formattedString)
                
                
                for segment in result.bestTranscription.segments {
                    print("Segment confidence: \(segment.confidence) -> \(segment.substring)")
                    self.confidenceCheck.append(segment.confidence)
                }
                
                self.checkPronounciationResult(self.result, self.firstAnswer[self.currentProgress], self.secondAnswer[self.currentProgress])
                
                self.audioEngine.stop()
                node.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.setImage(#imageLiteral(resourceName: "mic button"), for: .normal)
                print("Finished recording")
            } else {
                self.result = result.bestTranscription.formattedString
                self.userReplyLabel.text = self.result
            }
        }
    }
}

extension StringProtocol {
    var words: [SubSequence] {
        return split{ !$0.isLetter }
    }
}

extension SelfTalkViewController {
    func correctSound() {
        let pathToSound = Bundle.main.path(forResource: "Correct", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
            print("There's a problem playing the SFX")
        }
    }
    
    func wrongSound() {
        let pathToSound = Bundle.main.path(forResource: "Wrong", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
            print("There's a problem playing the SFX")
        }
    }
}
