//
//  RecordViewController.swift
//  SoundBoard
//
//  Created by Axel Vencatareddy on 05/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var recordButton: UIButton!
  
  var audioRecorder: AVAudioRecorder?
  var audioPlayer: AVAudioPlayer?
  var audioURL : URL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupRecorder()
    playButton.isEnabled = false
    addButton.isEnabled = false
    titleTextField.delegate = self
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
      audioURL = NSURL.fileURL(withPathComponents: pathComponents)
      
      // Create Settings for the Audio Recorder
      var settings: [String : AnyObject] = [:]
      settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
      settings[AVSampleRateKey] = 44100.0 as AnyObject
      settings[AVNumberOfChannelsKey] = 2 as AnyObject
      
      
      // Create AudioRecorder Object
      
      audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
      audioRecorder?.prepareToRecord()
    } catch let error as NSError {
      print("An error occured while setting up the session : \(error)")
    }
    

  }
  
  @IBAction func recordTapped(_ sender: AnyObject) {

    if audioRecorder!.isRecording {
      // Stop the recording
      audioRecorder!.stop()
      
      // Change button title to Record
      recordButton.setTitle("Record", for: .normal)
      
      
      playButton.isEnabled = true
      addButton.isEnabled = true
    } else {
      // Start the recording
      audioRecorder!.record()
      
      // Change button title to Stop
      recordButton.setTitle("Stop", for: .normal)
    }
  }
  
  @IBAction func playTapped(_ sender: AnyObject) {
    do {
      try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
      audioPlayer!.play()
    } catch {}
  }
  
  @IBAction func addTapped(_ sender: AnyObject) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let audio = Audio(context: context)
    
    if titleTextField.text != nil {
      audio.title = titleTextField.text
    } else {
      audio.title = "audio without name"
    }
    audio.audio = NSData(contentsOf: audioURL!)
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    // Pop the ViewController
    navigationController!.popViewController(animated: true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}
