//
//  ViewController.swift
//  MMPlayer
//
//  Created by Sam Maroun on 08/01/2021.
//

import UIKit
import AVFoundation
import MediaPlayer


class ViewController: UIViewController {
    
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playlistButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var totalLenghtSpend: UILabel!
    @IBOutlet weak var progressTimer: UILabel!
    @IBOutlet weak var progressSongSlider: UISlider!
    //@IBOutlet weak var playerProgressSlieder: UISlider!
    
    var isRunning = false
    
    @IBAction func startMusic(_ sender: Any) {
        if !isRunning{
            playButton.setImage(UIImage(named: "play"), for: .normal)
            
            
            isRunning = true
        }
        else{
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            
            isRunning = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        playButton.isEnabled = true
        playButton.isHidden = false
        
        nextButton.isEnabled = true
        nextButton.isHidden = false
        
        previousButton.isEnabled = true
        previousButton.isHidden = false
        
        playlistButton.isEnabled = true
        playlistButton.isHidden = false
        
        repeatButton.isEnabled = true
        repeatButton.isHidden = false
        
        shuffleButton.isEnabled = true
        shuffleButton.isHidden = false
        
        coverImage.isHidden = false
        albumName.isHidden = false
        songName.isHidden = false
        artistName.isHidden = false
        totalLenghtSpend.isHidden = false
        progressTimer.isHidden = false
        progressSongSlider.isHidden = false
    }


    //MARK:- UITableView : Montre le nom artist et song
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        var songNameDict = NSDictionary();
        songNameDict = audioList.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let songName = songNameDict.value(forKey: "songName") as! String
        
        var albumNameDict = NSDictionary();
        albumNameDict = audioList.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let albumName = albumNameDict.value(forKey: "albumName") as! String
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont(name: "BodoniSvtyTwoITCTT-BookIta", size: 25.0)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = songName
        
        cell.detailTextLabel?.font = UIFont(name: "BodoniSvtyTwoITCTT-Book", size: 16.0)
        cell.detailTextLabel?.textColor = UIColor.white
        cell.detailTextLabel?.text = albumName
        return cell
    }
    //retourne sous forme de tableau le nom de la musique l'artiste....

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    
    
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath){
        tableView.backgroundColor = UIColor.clear
        
        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.clear
        cell.backgroundView = backgroundView
        cell.backgroundColor = UIColor.clear
    }

    
    
    
 
}
