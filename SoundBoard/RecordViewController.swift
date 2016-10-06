//
//  RecordViewController.swift
//  SoundBoard
//
//  Created by Axel Vencatareddy on 05/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  
  var audioRecorder: AVAudioRecorder?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupRecorder()
  }
  
  func setupRecorder() {
    
    do {
      // Create an Audio Session and Setting it up
      let session = AVAudioSession.sharedInstance()
      
      try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
      try session.overrideOutputAudioPort(.speaker)
      try session.setActive(true)

      // Create URL for the Audio Recorder
      let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
      let pathComponents = [basePath, "audio.m4a"]
      let audioURL = NSURL.fileURL(withPathComponents: pathComponents)
      
      // Create Settings for the Audio Recorder
      var settings: [String : AnyObject] = [:]
      settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
      settings[AVSampleRateKey] = 44100.0 as AnyObject?
      settings[AVNumberOfChannelsKey] = 2 as AnyObject?
      
      
      // Create AudioRecorder Object
      
      audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
      audioRecorder?.prepareToRecord()
    } catch {
      print("An error occured while setting up the session")
    }
    

  }
  
  @IBAction func recordTapped(_ sender: AnyObject) {
  }
  
  @IBAction func playTapped(_ sender: AnyObject) {
  }
  
  @IBAction func addTapped(_ sender: AnyObject) {
  }
}
