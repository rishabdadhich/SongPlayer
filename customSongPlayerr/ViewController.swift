//
//  ViewController.swift
//  customSongPlayerr
//
//  Created by Rishabh Dadhich on 14/03/19.
//  Copyright © 2019 Rishabh Dadhich. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation


class ViewController: UIViewController,MPMediaPickerControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    var avMusicPlayer: AVAudioPlayer!
    var mpMediapicker: MPMediaPickerController!
    var mediaItems = [MPMediaItem]()
    let currentIndex = 0
    var songPLayer = AVAudioPlayer()

    @IBOutlet weak var lblView: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let pickerController = MPMediaPickerController(mediaTypes: .music)

        pickerController.delegate = self
//        present(pickerController, animated: true)
        
        tblView.delegate = self
        tblView.dataSource = self
    }

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        mediaItems.append(mediaItemCollection.items[0])
        updatePlayer()
        
        tblView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updatePlayer(){
        let item = mediaItems[currentIndex]
        // DO-TRY-CATCH try to setup AVAudioPlayer with the path, if successful, sets up the AVMusicPlayer, and song values.
        if let path: NSURL = item.assetURL as NSURL? {
            do
            {
                avMusicPlayer = try AVAudioPlayer(contentsOf: path as URL)
                avMusicPlayer.enableRate = true
                avMusicPlayer.rate = 1.0
                avMusicPlayer.numberOfLoops = 0
                avMusicPlayer.currentTime = 0
            }
            catch
            {
                avMusicPlayer = nil
            }
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func picker(_ sender: AnyObject) {
        mpMediapicker = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        mpMediapicker.allowsPickingMultipleItems = false
        mpMediapicker.delegate = self
        self.present(mpMediapicker, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell")
        
        cell?.textLabel?.text = mediaItems[indexPath.item].albumTitle
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        prepareSongAndSession(index: indexPath.row)
    }
    
    @IBAction func next(_ sender: Any) {
    }
    @IBAction func previous(_ sender: Any) {
    }
    @IBAction func play(_ sender: Any) {
        if songPLayer.isPlaying {
            songPLayer.pause()
        }
        
    }
    
    func prepareSongAndSession(index:Int) {
        do {
            songPLayer = try AVAudioPlayer(contentsOf: mediaItems[index].assetURL!)
            
            songPLayer.prepareToPlay()
            
//            let audioSession = AVAudioSession.sharedInstance()
//
//            do {
//                try audioSession.setCategory(<#T##category: AVAudioSession.Category##AVAudioSession.Category#>, mode: <#T##AVAudioSession.Mode#>, policy: <#T##AVAudioSession.RouteSharingPolicy#>, options: <#T##AVAudioSession.CategoryOptions#>)
//            } catch <#pattern#> {
//                <#statements#>
//            }
        } catch let songPlayerError {
            print(songPlayerError)
        }
        
        songPLayer.play()
    }
    
    
}

