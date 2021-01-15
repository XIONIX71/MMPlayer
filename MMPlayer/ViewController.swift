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

    var audioList:NSArray!
    var effectToggle = true
    var audioPlayer:AVAudioPlayer! = nil
    var currentAudioIndex = 0
    var currentAudio = ""
    var currentAudioPath:URL!
    var isTableViewOnscreen = false
    var shuffleState = false
    var repeatState = false
    var shuffleArray = [Int]()
    
    
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

        super.viewDidLoad()
        
       //Fonction à coder plus tard pour les parametrage de la lecture audio mais aussi pour regler le numero du son en cours
        // retrieveSavedTrackNumber()
        // prepareAudio()
        // updateLabels()
        // assingSliderUI()
        // setRepeatAndShuffle()
        // retrievePlayerProgressSliderValue()
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

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        currentAudioIndex = (indexPath as NSIndexPath).row
        
        effectToggle = !effectToggle
        let showList = UIImage(named: "list")
        let removeList = UIImage(named: "listS")
        playlistButton.setImage(effectToggle ? showList : removeList, for: UIControl.State())
        let play = UIImage(named: "play")
        let pause = UIImage(named: "pause")
        playButton.setImage(audioPlayer.isPlaying ? pause : play, for: UIControl.State())
        
        //à implémenter
        //blurView.isHidden = true
        //animateTableViewToOffScreen() 
        // prepareAudio()
        // playAudio()

    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override var prefersStatusBarHidden : Bool {
        
        if isTableViewOnscreen{
            return true
        }else{
            return false
        }
    }

    
    func setRepeatAndShuffle(){
        shuffleState = UserDefaults.standard.bool(forKey: "shuffleState")
        repeatState = UserDefaults.standard.bool(forKey: "repeatState")
        if shuffleState == true {
            shuffleButton.isSelected = true
        } else {
            shuffleButton.isSelected = false
        }
        
        if repeatState == true {
            repeatButton.isSelected = true
        }else{
            repeatButton.isSelected = false
        }
    
    }
    
    
    // Á garder pour plus tard
    // override func viewWillAppear(_ animated: Bool) {
    //     super.viewWillAppear(animated)
    //     self.tableViewContainerTopConstrain.constant = 1000.0
    //     self.tableViewContainer.layoutIfNeeded()
    //     blurView.isHidden = true
    // }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        coverImage.setRounded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 
}
