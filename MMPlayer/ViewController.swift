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
        
        /*playButton.isEnabled = true
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
        progressSongSlider.isHidden = false*/
    }
    
    
    
    
 
}
