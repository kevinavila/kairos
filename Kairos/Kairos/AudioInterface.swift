//
//  AudioInterface.swift
//  Kairos
//
//  Created by Kevin Avila on 11/10/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit
import AVFoundation

class AudioInterface: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    //weak var audioRecorderDelegate: AudioRecorderViewControllerDelegate?
    
    var timeTimer: Timer!
    var milliseconds: Int! = 0
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var outputURL: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let outputPath = documentsPath.appendingPathComponent("userRecording.m4a")
        outputURL = NSURL(fileURLWithPath: outputPath)
        
        let settings = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC), AVSampleRateKey: NSNumber(value: 44100), AVNumberOfChannelsKey: NSNumber(value: 2)]
        try! recorder = AVAudioRecorder(url: outputURL as URL, settings: settings)
        recorder.delegate = self
        recorder.prepareToRecord()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            NSLog("Error: \(error)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AudioInterface.stopRecording), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func toggleRecord(sender: AnyObject) {
        
        timeTimer?.invalidate()
        
        if recorder.isRecording {
            recorder.stop()
        } else {
            milliseconds = 0
            timeLabel.text = "00:00.00"
            timeTimer = Timer.scheduledTimer(timeInterval: 0.0167, target: self, selector: #selector(AudioInterface.updateTimeLabel), userInfo: nil, repeats: true)
            recorder.deleteRecording()
            recorder.record()
        }
        
        updateControls()
        
    }
    
    func stopRecording(sender: AnyObject) {
        if recorder.isRecording {
            toggleRecord(sender: sender)
        }
    }
    
    @IBAction func play(sender: AnyObject) {
        
        if let player = player {
            player.stop()
            self.player = nil
            updateControls()
            return
        }
        
        do {
            try player = AVAudioPlayer(contentsOf: outputURL as URL)
        }
        catch let error as NSError {
            NSLog("error: \(error)")
        }
        
        player?.delegate = self
        player?.play()
        
        updateControls()
    }
    
    @IBAction func userClickedCancel(_ sender: AnyObject) {
        cleanup()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userClickedSave(_ sender: AnyObject) {
        cleanup()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateControls() {
        
//        UIView.animate(withDuration: 0.2) { () -> Void in
//            self.recordButton.titleLabel?.text = "STOP"
//        }
        if (recorder.isRecording) {
            self.recordButton.setTitle("STOP", for: .normal)
        } else {
            self.recordButton.setTitle("Record", for: .normal)
        }
        
        if let _ = player {
            playButton.setTitle("STOP", for: .normal)
            recordButton.isEnabled = false
        } else {
            playButton.setTitle("Play", for: .normal)
            recordButton.isEnabled = true
        }
        
        playButton.isEnabled = !recorder.isRecording
        playButton.alpha = recorder.isRecording ? 0.25 : 1
        saveButton.isEnabled = !recorder.isRecording
        
    }
    
    func updateTimeLabel(timer: Timer) {
        milliseconds = milliseconds + 1
        let milli = (milliseconds % 60) + 39
        let sec = (milliseconds / 60) % 60
        let min = milliseconds / 3600
        timeLabel.text = NSString(format: "%02d:%02d.%02d", min, sec, milli) as String
    }
    
    func cleanup() {
        timeTimer?.invalidate()
        if recorder.isRecording {
            recorder.stop()
            recorder.deleteRecording()
        }
        if let player = player {
            player.stop()
            self.player = nil
        }
    }

}
