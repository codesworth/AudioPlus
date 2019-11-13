//
//  ViewController.swift
//  AudioPlus
//
//  Created by Shadrach Mensah on 13/11/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var penguin: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

      var audioStatus: AudioStatus = AudioStatus.Stopped
      
      var audioRecorder: AVAudioRecorder!
      var audioPlayer: AVAudioPlayer!
      
      // MARK: - Setup
      override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
      }

      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
      }
      
    override var prefersStatusBarHidden:Bool {
        return true
      }
      
      // MARK: - Controls
      @IBAction func onRecord(sender: UIButton) {
        if appHasMicAccess == true { // Look into why I did this ;]
          if audioStatus != .Playing {
            
            switch audioStatus {
            case .Stopped:
                recordButton.setBackgroundImage(UIImage(named: "button-record1"), for: UIControl.State.normal)
              record()
            case .Recording:
                recordButton.setBackgroundImage(UIImage(named: "button-record"), for: UIControl.State.normal)
              stopRecording()
            default:
              break
            }
          }
        } else {
            recordButton.isEnabled = false
          let theAlert = UIAlertController(title: "Requires Microphone Access",
            message: "Go to Settings > PenguinPet > Allow PenguinPet to Access Microphone.\nSet switch to enable.",
            preferredStyle: UIAlertController.Style.alert)
          
            theAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.view?.window?.rootViewController?.present(theAlert, animated: true, completion:nil)
        }

      }

      @IBAction func onPlay(sender: UIButton) {
        if audioStatus != .Recording {
          
          switch audioStatus {
          case .Stopped:
            play()
          case .Playing:
            stopPlayback()
          default:
            break
          }
        }
      }

      func setPlayButtonOn(flag: Bool) {
        if flag == true {
            playButton.setBackgroundImage(UIImage(named: "button-play1"), for: UIControl.State.normal)
        } else {
            playButton.setBackgroundImage(UIImage(named: "button-play"), for: UIControl.State.normal)
        }
      }

      
    }

    // MARK: - AVFoundation Methods
    extension ViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
      
      // MARK: Recording
      func setupRecorder() {
        let fileURL = getURLforMemo()
        let recordSettings = [
            AVFormatIDKey : kAudioFormatLinearPCM,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]  as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch let error {
            print("Error Occurred with initializing Recorder: \(error.localizedDescription)")
        }
      }
      
      func record() {
        audioStatus = .Recording
        audioRecorder.record()
      }
      
      func stopRecording() {
        recordButton.setBackgroundImage(UIImage(named: "button-record"), for: UIControl.State.normal)
        audioStatus = .Stopped
        audioRecorder.stop()
      }
      
      // MARK: Playback
      func  play() {
        setPlayButtonOn(flag: true)
        audioStatus = .Playing
      }
      
      func stopPlayback() {
        setPlayButtonOn(flag: false)
        audioStatus = .Stopped
      }
      
      // MARK: Delegates
      
      // MARK: Notifications
      
      // MARK: - Helpers
      
      func getURLforMemo() -> URL {
        let tempDir = NSTemporaryDirectory()
        let filePath = tempDir + "/TempMemo.caf"
        return URL(fileURLWithPath: filePath)
      }
    }

