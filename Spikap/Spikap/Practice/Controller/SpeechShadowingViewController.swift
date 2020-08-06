//
//  SpeechShadowingViewController.swift
//  Spikap
//
//  Created by Maria Jeffina on 22/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import AVKit
import SoundAnalysis
import CloudKit

class SpeechShadowingViewController: UIViewController, AVAudioRecorderDelegate, SFSpeechRecognizerDelegate {
    
    //MARK: Variables
    var topic = "Travelling"
    var totalProgress = 8
    var currentProgress = 0
    var activity: activityData!
    var activityContents = [activityContentData]()
    
    var content = ""
    var contents = ["Airfare", "Baggage", "Cruise", "Departure", "Explore", "Foreign", "Itinerary", "Journey"]
    var contentsToken = [["air", "fare"], ["ba", "ggage"], ["cruise"], ["de", "par", "ture"], ["ex", "plore"], ["fo", "reign"], ["i", "ti", "ne", "ra", "ry"], ["jour", "ney"]]
    var info = ["(Noun) The price of a passenger ticket for travel by aircraft.", "(Noun) Personal belongings packed in suitcases for traveling; luggage.", "(Verb) Sail about in an area without a precise destination, especially for pleasure", "(Noun) The action of leaving, especially to start a journey.", "(Verb) Travel in or through (an unfamiliar country or area) in order to learn about or familiarize oneself with it.", "(Adjective) Of, from, in, or characteristic of a country or language other than one's own.", "(Noun) A planned route or journey.", "(Noun) An act of traveling from one place to another."]
    var speechToTextResult: String = ""
    
    private let audioEngine = AVAudioEngine()
    private var soundClassifier = English()      //MLmodel
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let synthesizer = AVSpeechSynthesizer()
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    var inputFormat: AVAudioFormat!
    var streamAnalyzer: SNAudioStreamAnalyzer!
    let queue = DispatchQueue(label: "iCloud.com.aries.Spikap")
    var results = [(label: String, confidence: Float)]()
    var testResult = [(label: String, confidence: Float)]()
    
    
    
    var isRecording: Bool = false
    var isCorrect: Bool = false
    
    //MARK: IB Outlets
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var contentInfoLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var progressBarView: UICollectionView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        setupNextButton()
        
        playAudioButton.isEnabled = true
//        nextButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeToSystemFont(label: topicLabel, fontSize: 20)
        
        topicLabel.text = activity.topic
        
        
        
        //Text to speech
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadContents()
        
        
        
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
    
    func loadContents() {
        activityContents = []
        let idToFetch = CKRecord.Reference(recordID: activity.recordID, action: .none)

        let pred = NSPredicate(format: "activity = %@", idToFetch)
        let query = CKQuery(recordType: "ActivityContent", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 99
        
        var fetchContent = [activityContentData]()
        
        operation.recordFetchedBlock = {
            record in
            let content = activityContentData()
            content.recordID = record.recordID
            content.contents = record["contents"]
            content.contentToken = record["contentToken"]
            content.info = record["info"]
            
            fetchContent.append(content)
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.activityContents = fetchContent
                    self.questionLabel.text = self.activityContents[0].contents
                    self.contentInfoLabel.text = self.activityContents[0].info[0]
                    self.setupTokenLabel(progress: self.currentProgress)
                } else {
                    print("Error fetching data")
                }
            }
        }
        CKContainer.init(identifier: "iCloud.com.aries.Spikap").publicCloudDatabase.add(operation)
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
            questionLabel.text = activityContents[currentProgress].contents
            contentInfoLabel.text = activityContents[currentProgress].info[0]
            setupTokenLabel(progress: currentProgress)
            progressBarView.reloadData()
//            nextButton.isEnabled = false
            questionLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            feedbackLabel.text = "Say the word!"
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
            recordButton.setImage(#imageLiteral(resourceName: "mic button"), for: .normal)
            playAudioButton.isEnabled = true
//            checkResult()
            
        } else {
            try! startRecording()
//            prepareForRecording()
//            createClassificationRequest()
            recordButton.setImage(#imageLiteral(resourceName: "record button"), for: .normal)
            playAudioButton.isEnabled = false
        }
    }
    @IBAction func playAudioSpeech(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: questionLabel.text ?? "")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.2
        utterance.volume = 10.0
        
        synthesizer.speak(utterance)
    }
    
    //MARK: Functions
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    private func startAudioEngine() {
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            showAudioError()
        }
    }
    
    private func checkSpeechToText() {
        let tokens = activityContents[currentProgress].contentToken
        var finalString: [String] = []
        var goodToken: [String] = []
        var badToken: [String] = []
        var isCorrect = false
        print(speechToTextResult.words)
        for word in speechToTextResult.words {
            if word.uppercased() == activityContents[currentProgress].contents.uppercased() {
                print("The whole word is correct!")
                isCorrect = true
                break
            } else {
                var temp: [String] = []
                for token in tokens! {
                    if token.uppercased() == word.uppercased() {
                        temp.append(token)
                        goodToken.append(String(token))
                    }
                }
                finalString.append(String(word))
            }
        }
        
        for wordToken in goodToken {
            for token in tokens! {
                if wordToken.uppercased() != token.uppercased() {
                    //token yang gaada di nilainya dia.
                    badToken.append(token)
                }
            }
        }
        
        if isCorrect {
            questionLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)
            feedbackLabel.text = "Good job!"
            nextButton.isEnabled = true
            correctSound()
        } else {
            if finalString.joined().uppercased() == activityContents[currentProgress].contents.uppercased() {
                questionLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)
                feedbackLabel.text = "Good job!"
                nextButton.isEnabled = true
                correctSound()
            } else {
                if badToken.count == 0 {
                    questionLabel.textColor = #colorLiteral(red: 0.8078431373, green: 0.02745098039, blue: 0.3333333333, alpha: 1)
                    feedbackLabel.text = "Oops, we didn't catch that. Try again"
//                    nextButton.isEnabled = false
                    wrongSound()
                } else {
                    questionLabel.textColor = #colorLiteral(red: 0.8078431373, green: 0.02745098039, blue: 0.3333333333, alpha: 1)
                    feedbackLabel.text = "You're still struggling with: \(badToken.joined(separator: ", "))"
//                    nextButton.isEnabled = false
                    wrongSound()
                }
            }
        }
        
    }
    
    private func checkResult() {
        let tokens = activityContents[currentProgress].contentToken
        var temp: [String] = []
        var tempWrong: [String] = []
        isCorrect = false
        for (index, result) in testResult.enumerated() {
            if (index < tokens!.count) {
                if result.label.uppercased().contains(activityContents[currentProgress].contents.uppercased()) {
                    if result.confidence < 30 {
                        isCorrect = false
                    } else {
                        isCorrect = true
                        break
                    }
                } else  {
                    for token in tokens! {
                        if result.label.uppercased().contains(token.uppercased()) {
                            if (Int(result.confidence) >= 30) {
                                //pronounce udh bener tapi masih belum complete
                                temp.append(token)
                            } else {
                                //pronounce masih belum bener, jadi % nya kecil
                                tempWrong.append(token)
                            }
                        }
                    }
                }
            }
        }
        
        
        if (isCorrect) {
            questionLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)
            feedbackLabel.text = "Good job!"
            nextButton.isEnabled = true
            correctSound()
        } else {
            if (temp.joined().uppercased() == activityContents[currentProgress].contents.uppercased()) {
                questionLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)
                feedbackLabel.text = "Good job!"
                nextButton.isEnabled = true
                correctSound()
            } else  {
                if (temp.count == 0) {
                    questionLabel.textColor = #colorLiteral(red: 0.8078431373, green: 0.02745098039, blue: 0.3333333333, alpha: 1)
                    feedbackLabel.text = "Oops, we didn't catch that. Try again"
//                    nextButton.isEnabled = false
                    wrongSound()
                } else {
                    if (tempWrong.count != 0) {
                        questionLabel.textColor = #colorLiteral(red: 0.8078431373, green: 0.02745098039, blue: 0.3333333333, alpha: 1)
                        feedbackLabel.text = "Well, here's what we can hear from you: \"\(temp.joined(separator: ", "))\". You're still struggling with: \"\(tempWrong.joined(separator: ", "))\""
//                        nextButton.isEnabled = false

                        wrongSound()
                    }
                    else {
                        questionLabel.textColor = #colorLiteral(red: 0.8078431373, green: 0.02745098039, blue: 0.3333333333, alpha: 1)
                        feedbackLabel.text = "Well, here's what we can hear from you: \"\(temp.joined(separator: ", "))\""
//                        nextButton.isEnabled = false
                        wrongSound()
                    }
                }
            }
        }
    }
    
    private func prepareForRecording() {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        streamAnalyzer = SNAudioStreamAnalyzer(format: recordingFormat)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            [unowned self] (buffer, when) in
            self.queue.async {
                self.streamAnalyzer.analyze(buffer,
                                            atAudioFramePosition: when.sampleTime)
            }
        }
        startAudioEngine()
    }
    
    private func createClassificationRequest() {
        do {
            let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            try streamAnalyzer.add(request, withObserver: self)
        } catch {
            fatalError("error adding the classification request")
        }
    }
    
    func checkPronounciationResult(_ result: String, _ masterText: String) {
        if (result.uppercased().contains(masterText.uppercased())) {
            questionLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.6274509804, blue: 0.1019607843, alpha: 1)
            nextButton.isEnabled = true
        } else {
            questionLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            nextButton.isEnabled = false
        }
    }
    
    func setupNextButton(){
        nextButton.imageView?.contentMode = .scaleAspectFit
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        nextButton.layer.isHidden = false
    }
    
    func setupTokenLabel(progress: Int){
        let tokens = activityContents[progress].contentToken
        var finalString: String = ""
        for index in 0 ..< tokens!.count {
            let value = tokens![index]
           
            if index == tokens!.count - 1 {
                finalString = finalString + value
            } else {
                finalString = finalString + value + " - "
            }
        }
        tokenLabel.text = finalString
    }
}


//MARK: CollectionView
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

//MARK: Speech Recognition
extension SpeechShadowingViewController {
    private func startRecording() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
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
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) {
            result, error in
            
            guard let result = result else { return }
            
            
            if result.isFinal {
                print(result.bestTranscription.formattedString)
                
                
                for segment in result.bestTranscription.segments {
                    print("Segment confidence: \(segment.confidence) -> \(segment.substring)")
                }
                
                self.speechToTextResult = result.bestTranscription.formattedString
                self.checkSpeechToText()
                
                
                self.audioEngine.stop()
                node.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.setImage(#imageLiteral(resourceName: "mic button"), for: .normal)
                print("Finished recording")
            } else {
                self.speechToTextResult = result.bestTranscription.formattedString
            }
        }
    }
}

//MARK: MLModel Result Request
extension SpeechShadowingViewController: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }
        var temp = [(label: String, confidence: Float)]()
        let sorted = result.classifications.sorted { (first, second) -> Bool in
            return first.confidence > second.confidence
        }
        for classification in sorted {
            let confidence = classification.confidence * 100
            if confidence > 5 {
                temp.append((label: classification.identifier, confidence: Float(confidence)))
            }
        }
        print("temp result: \(temp)")
        testResult = temp
    }
}

//MARK: Alert
extension SpeechShadowingViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAudioError() {
        let errorTitle = "Audio Error"
        let errorMessage = "Recording is not possible at the moment."
        self.showAlert(title: errorTitle, message: errorMessage)
    }
}

//MARK: Music Assets
extension SpeechShadowingViewController {
    func correctSound() {
        let pathToSound = Bundle.main.path(forResource: "Correct", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 10.0
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
            audioPlayer?.volume = 10.0
            audioPlayer?.play()
        } catch {
            print("There's a problem playing the SFX")
        }
    }
    
    func playSpeech(resourceURL: CKAsset) {
        //resourceURL -> arrayOfActivityContents[currentProgress].contentAudio
        let audioURL = resourceURL.fileURL
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}
