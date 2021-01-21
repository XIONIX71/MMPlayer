//
//  ViewController.swift
//  MMPlayer
//
//  Created by Sam Maroun on 08/01/2021.
//

import UIKit
import AVFoundation
import MediaPlayer


class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate {

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
    var timer:Timer!
    var audioLength = 0.0
    var totalLengthOfAudio = ""
    
    
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

    func showMediaInfo(){
        let artistName = readArtistNameFromPlist(currentAudioIndex)
        let songName = readSongNameFromPlist(currentAudioIndex)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist : artistName,  MPMediaItemPropertyTitle : songName]
    }
    
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
      
        retrieveSavedTrackNumber()
        prepareAudio()
        updateLabels()
        assingSliderUI()
        setRepeatAndShuffle()
        retrieveprogressSongSliderValue()
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
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = songName
        
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
        prepareAudio()
        playAudio()

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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- AVAudioPlayer
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag == true {
            
            if shuffleState == false && repeatState == false {
                // do nothing
                playButton.setImage( UIImage(named: "play"), for: UIControl.State())
                return
            
            } 
            else if shuffleState == false && repeatState == true {
                prepareAudio()
                playAudio()
            
            } 
            else if shuffleState == true && repeatState == false {
            //Shuffle logique, mettre le son courant dans un tableau et le son d'après viendra aleatoirement
               shuffleArray.append(currentAudioIndex)
                if shuffleArray.count >= audioList.count {
                playButton.setImage( UIImage(named: "play"), for: UIControl.State())
                return
                }                
                var randomIndex = 0
                var newIndex = false
                while newIndex == false {
                    randomIndex =  Int(arc4random_uniform(UInt32(audioList.count)))
                    if shuffleArray.contains(randomIndex) {
                        newIndex = false
                    }
                    else{
                        newIndex = true
                    }
                }
                currentAudioIndex = randomIndex
                prepareAudio()
                playAudio()
            
            } else if shuffleState == true && repeatState == true {
                //shuffle fin
                shuffleArray.append(currentAudioIndex)
                if shuffleArray.count >= audioList.count {
                    shuffleArray.removeAll()
                }
                
                
                var randomIndex = 0
                var newIndex = false
                while newIndex == false {
                    randomIndex =  Int(arc4random_uniform(UInt32(audioList.count)))
                    if shuffleArray.contains(randomIndex) {
                        newIndex = false
                    }
                    else{
                        newIndex = true
                    }
                }
                currentAudioIndex = randomIndex
                prepareAudio()
                playAudio()
            
            }
            
        }
    }

    //Sets audio file URL
    func setCurrentAudioPath(){
        currentAudio = readSongNameFromPlist(currentAudioIndex)
        currentAudioPath = URL(fileURLWithPath: Bundle.main.path(forResource: currentAudio, ofType: "mp3")!)
        print("\(String(describing: currentAudioPath))")
    }
    
    
    func saveCurrentTrackNumber(){
        UserDefaults.standard.set(currentAudioIndex, forKey:"currentAudioIndex")
        UserDefaults.standard.synchronize()
        
    }
    
    func retrieveSavedTrackNumber(){
        if let currentAudioIndex_ = UserDefaults.standard.object(forKey: "currentAudioIndex") as? Int{
            currentAudioIndex = currentAudioIndex_
        }
        else{
            currentAudioIndex = 0
        }
    }

    func prepareAudio(){
        setCurrentAudioPath()
        do {
            //garder le lecteur en marche en background
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)))
        } 
        catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } 
        catch _ {
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        audioPlayer = try? AVAudioPlayer(contentsOf: currentAudioPath)
        audioPlayer.delegate = self
        audioLength = audioPlayer.duration
        progressSongSlider.maximumValue = CFloat(audioPlayer.duration)
        progressSongSlider.minimumValue = 0.0
        progressSongSlider.value = 0.0
        audioPlayer.prepareToPlay()
        showTotalSongLength()
        updateLabels()
        progressTimer.text = "00:00"
    }

    func  playAudio(){
        audioPlayer.play()
        startTimer()
        updateLabels()
        saveCurrentTrackNumber()
        showMediaInfo()
    }
    
    func playNextAudio(){
        currentAudioIndex += 1
        if currentAudioIndex>audioList.count-1{
            currentAudioIndex -= 1
            
            return
        }
        if audioPlayer.isPlaying{
            prepareAudio()
            playAudio()
        }else{
            prepareAudio()
        }
        
    }

    func playPreviousAudio(){
        currentAudioIndex -= 1
        if currentAudioIndex<0{
            currentAudioIndex += 1
            return
        }
        if audioPlayer.isPlaying{
            prepareAudio()
            playAudio()
        }else{
            prepareAudio()
        }
        
    }
    
    
    func stopAudioplayer(){
        audioPlayer.stop();
        
    }
    
    func pauseAudioPlayer(){
        audioPlayer.pause()
        
    }
    
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update(_:)), userInfo: nil,repeats: true)
            timer.fire()
        }
    }
    
    deinit {
        timer.invalidate()
    }
    
    func stopTimer(){
        timer.invalidate()
        
    }
    
     @objc func update(_ timer: Timer){
        if !audioPlayer.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
        progressTimer.text  = "\(time.minute):\(time.second)"
        progressSongSlider.value = CFloat(audioPlayer.currentTime)
        UserDefaults.standard.set(progressSongSlider.value , forKey: "progressSongSliderValue")

        
    }

    func retrieveprogressSongSliderValue(){
        let progressSongSliderValue =  UserDefaults.standard.float(forKey: "progressSongSliderValue")
        if progressSongSliderValue != 0 {
            progressSongSlider.value  = progressSongSliderValue
            audioPlayer.currentTime = TimeInterval(progressSongSliderValue)
            
            let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
            progressTimer.text  = "\(time.minute):\(time.second)"
            progressSongSlider.value = CFloat(audioPlayer.currentTime)
            
        }
        else{
            progressSongSlider.value = 0.0
            audioPlayer.currentTime = 0.0
            progressTimer.text = "00:00:00"
        }
    }

    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        return (minute,second)
    }
    

    
    func showTotalSongLength(){
        calculateSongLength()
        totalLenghtSpend.text = totalLengthOfAudio
    }
    
    
    func calculateSongLength(){
        let time = calculateTimeFromNSTimeInterval(audioLength)
        totalLengthOfAudio = "\(time.minute):\(time.second)"
    }
    
    
    //Read plist file and creates an array of dictionary
    func readFromPlist(){
        let path = Bundle.main.path(forResource: "list", ofType: "plist")
        audioList = NSArray(contentsOfFile:path!)
    }
    
    func readArtistNameFromPlist(_ indexNumber: Int) -> String {
        readFromPlist()
        var infoDict = NSDictionary();
        infoDict = audioList.object(at: indexNumber) as! NSDictionary
        let artistName = infoDict.value(forKey: "artistName") as! String
        return artistName
    }
    
    func readAlbumNameFromPlist(_ indexNumber: Int) -> String {
        readFromPlist()
        var infoDict = NSDictionary();
        infoDict = audioList.object(at: indexNumber) as! NSDictionary
        let albumName = infoDict.value(forKey: "albumName") as! String
        return albumName
    }

    
    func readSongNameFromPlist(_ indexNumber: Int) -> String {
        readFromPlist()
        var songNameDict = NSDictionary();
        songNameDict = audioList.object(at: indexNumber) as! NSDictionary
        let songName = songNameDict.value(forKey: "songName") as! String
        return songName
    }
    
    func readArtworkNameFromPlist(_ indexNumber: Int) -> String {
        readFromPlist()
        var infoDict = NSDictionary();
        infoDict = audioList.object(at: indexNumber) as! NSDictionary
        let artworkName = infoDict.value(forKey: "coverImage") as! String
        return artworkName
    }   
    
   
    func assingSliderUI() {
        let minImage = UIImage(named: "slider-track-fill")
        let maxImage = UIImage(named: "slider-track")
        let thumb = UIImage(named: "thumb")

        progressSongSlider.setMinimumTrackImage(minImage, for: UIControl.State())
        progressSongSlider.setMaximumTrackImage(maxImage, for: UIControl.State())
        progressSongSlider.setThumbImage(thumb, for: UIControl.State())

    
    }

    
    func updateLabels(){
        updateArtistNameLabel()
        updateAlbumNameLabel()
        updateSongNameLabel()
        updateCoverImage() 
    }
    
    
    func updateArtistNameLabel(){
        let artistName2 = readArtistNameFromPlist(currentAudioIndex)
        artistName.text = artistName2
    }
    func updateAlbumNameLabel(){
        let albumName2 = readAlbumNameFromPlist(currentAudioIndex)
        albumName.text = albumName2
    }
    
    func updateSongNameLabel(){
        let songName2 = readSongNameFromPlist(currentAudioIndex)
        songName.text = songName2
    }
    
    func updateCoverImage(){
        let artworkName = readArtworkNameFromPlist(currentAudioIndex)
        coverImage.image = UIImage(named: artworkName)
    }
}

fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
