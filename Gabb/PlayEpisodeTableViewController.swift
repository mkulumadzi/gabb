//
//  PlayEpisodeTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/27/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import AVFoundation

class PlayEpisodeTableViewController: UITableViewController {
    
    var podcast:NSDictionary!
    var episode:NSDictionary!
    var player:AVPlayer!
    var asset:AVURLAsset!
    var audioPlaying:Bool = false
    var updater : CADisplayLink! = nil
    
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var episodeDuration: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        formatView()
        initializePlayer()
        super.viewDidLoad()
    }
    
    func formatView() {
        
        if let image = podcast.valueForKey("image") as? UIImage {
            self.podcastImageView.image = image
        }
        if let podcastTitle = podcast.valueForKey("title") as? String {
            self.podcastTitle.text = podcastTitle
        }
        if let episodeTitle = episode.valueForKey("title") as? String {
            self.episodeTitle.text = episodeTitle
        }
    }
    
    func initializePlayer() {
        if let audioUrl = episode["audio_url"] as? String {
            print (audioUrl)
            if let url = NSURL(string: audioUrl) {
                asset = AVURLAsset(URL: url, options: nil)
                episodeDuration.text = stringFromCMTime(asset.duration)
                playTime.text = "00:00:00"
                
                progressBar.minimumValue = 0
                progressBar.maximumValue = 100
                progressBar.setValue(0, animated: false)
                
                player = AVPlayer(URL: url)
            }
        }
    }
    
    func stringFromCMTime(time: CMTime) -> String {
        let interval = Int(CMTimeGetSeconds(time))
        let seconds = interval % 60
        let minutes = (interval / 60 ) % 60
        let hours = (interval / 3600)
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds)
    }
    
//    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
//        let interval = Int(interval)
//        let seconds = interval % 60
//        let minutes = (interval / 60) % 60
//        let hours = (interval / 3600)
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // I freaking hate autolayout and table views. In any case, can't get the image cell to size correctly (it keeps setting the height to be 600), so setting the row heights manually for now.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            return screenSize.width
        case 1:
            return 80.0
        case 2:
            return 120.0
        default:
            return 80.0
        }
    }
    
    // MARK: - User Actions
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        if audioPlaying {
            pauseEpisode()
        }
        else {
            playEpisode()
        }
    }
    
    // MARK: - Private
    
    private func playEpisode() {
        if let pauseImage = UIImage(named: "pause") {
            playButton.setImage(pauseImage, forState: .Normal)
        }
        if let player = player {
            updater = CADisplayLink(target: self, selector: #selector(PlayEpisodeTableViewController.trackProgress))
            updater.frameInterval = 1
            updater.addToRunLoop(NSRunLoop.currentRunLoop(),forMode: NSRunLoopCommonModes)
            player.play()
            audioPlaying = true
        }
        tableView.reloadData()
    }
    
    private func pauseEpisode() {
        if let playImage = UIImage(named: "play") {
            playButton.setImage(playImage, forState: .Normal)
        }
        if let player = player {
            player.pause()
            audioPlaying = false
            updater.invalidate()
        }
    }
    
    func trackProgress() {
        playTime.text = stringFromCMTime(player.currentTime())
        let ratio = Float(CMTimeGetSeconds(player.currentTime()) / CMTimeGetSeconds(asset.duration))
        progressBar.setValue(ratio, animated: true)
        
//        print(player.currentTime())
//        print(CMTimeGetSeconds(player.currentTime()))
//        print(asset.duration)
//        print(CMTimeGetSeconds(asset.duration))
//        print("")
    }
    
//    let asset = AVURLAsset(URL: NSURL(fileURLWithPath: pathString), options: nil)
//    let audioDuration = asset.duration
//    let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
    
//    @IBAction func playAudio(sender: AnyObject) {
//        playButton.selected = !(playButton.selected)
//        if playButton.selected {
//            updater = CADisplayLink(target: self, selector: Selector("trackAudio"))
//            updater.frameInterval = 1
//            updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
//            let fileURL = NSURL(string: toPass)
//            player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
//            player.numberOfLoops = -1 // play indefinitely
//            player.prepareToPlay()
//            player.delegate = self
//            player.play()
//            startTime.text = "\(player.currentTime)"
//            theProgressBar.minimumValue = 0
//            theProgressBar.maximumValue = 100 // Percentage
//        } else {
//            player.stop()
//        }
//    }
//    
//    func trackAudio() {
//        var normalizedTime = Float(player.currentTime * 100.0 / player.duration)
//        theProgressBar.value = normalizedTime
//    }
//    
//    @IBAction func cancelClicked(sender: AnyObject) {
//        player.stop()
//        updater.invalidate()
//        dismissViewControllerAnimated(true, completion: nil)
//        
//    }

}
