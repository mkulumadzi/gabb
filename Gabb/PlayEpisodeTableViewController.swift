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
                playTime.text = episodeDuration.text?.characters.count > 7 ? "0:00:00" : "00:00"
                
                progressBar.minimumValue = 0
                progressBar.maximumValue = 100
                progressBar.setValue(0, animated: false)
                
                player = AVPlayer(URL: url)
            }
        }
    }
    
    func stringFromCMTime(time: CMTime) -> String {
        var timeString:String!
        let interval = Int(CMTimeGetSeconds(time))
        let seconds = interval % 60
        let minutes = (interval / 60 ) % 60
        let hours = (interval / 3600)
        
        if (hours > 0) {
            timeString = String(format:"%d:%02d:%02d", hours, minutes, seconds)
        }
        else {
            timeString = String(format:"%02d:%02d", minutes, seconds)
        }
        
        return timeString
    }

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
    
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        pauseEpisode()
        let newTime = getTimeFromProgressBar()
        playTime.text = stringFromCMTime(newTime)
    }
    
    @IBAction func sliderEditingEnded(sender: AnyObject) {
        let newTime = getTimeFromProgressBar()
        player.seekToTime(newTime)
        playEpisode()
    }
    
    func getTimeFromProgressBar() -> CMTime {
        let seconds = Double(Float(CMTimeGetSeconds(asset.duration)) * progressBar.value / 100)
        let newTime = CMTime(seconds: seconds, preferredTimescale: asset.duration.timescale)
        return newTime
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
        progressBar.setValue(ratio * 100, animated: true)
    }
    
    

}
