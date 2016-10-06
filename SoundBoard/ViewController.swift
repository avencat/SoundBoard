//
//  ViewController.swift
//  SoundBoard
//
//  Created by Axel Vencatareddy on 05/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  var audios: [Audio] = []
  var audioPlayer: AVAudioPlayer?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    // Fetch the audios and reload data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
      try audios = context.fetch(Audio.fetchRequest())
      tableView.reloadData()
    } catch {}
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return audios.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    
    cell.textLabel?.text = audios[indexPath.row].title
    
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let audio = audios[indexPath.row]
    do {
      try audioPlayer = AVAudioPlayer(data: audio.audio as! Data)
      audioPlayer?.play()
    } catch {}
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      context.delete(audios[indexPath.row])
      (UIApplication.shared.delegate as! AppDelegate).saveContext()
      do {
        try audios = context.fetch(Audio.fetchRequest())
        tableView.reloadData()
      } catch {}
    }
  }
}

