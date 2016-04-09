//
//  PlayEpisodeTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/27/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import AVFoundation

class PlayEpisodeTableViewController: UITableViewController, GabbPlayerDelegate {
    
    var podcast:NSDictionary!
    var episode:NSDictionary!
    
//    var audioPlaying:Bool = false
//    var updater : CADisplayLink! = nil
    
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
            gabber = GabbPlayer(audioUrl: audioUrl)
            gabber.delegate = self
            episodeDuration.text = gabber.episodeDuration
            playTime.text = gabber.playTime
            
            progressBar.minimumValue = 0
            progressBar.maximumValue = 100
            progressBar.setValue(0, animated: false)
        }
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
        if gabber.playing {
            if let pauseImage = UIImage(named: "pause") {
                playButton.setImage(pauseImage, forState: .Normal)
            }
            gabber.play()
        }
        else {
            if let playImage = UIImage(named: "play") {
                playButton.setImage(playImage, forState: .Normal)
            }
            gabber.pause()
        }
    }
    
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        gabber.pause()
        let newTime = getTimeFromProgressBar()
        playTime.text = newTime.toString()
    }
    
    @IBAction func sliderEditingEnded(sender: AnyObject) {
        let newTime = getTimeFromProgressBar()
        gabber.player.seekToTime(newTime)
        gabber.play()
    }
    
    func getTimeFromProgressBar() -> CMTime {
        let seconds = Double(Float(CMTimeGetSeconds(gabber.asset.duration)) * progressBar.value / 100)
        let newTime = CMTime(seconds: seconds, preferredTimescale: gabber.asset.duration.timescale)
        return newTime
    }
    
    // MARK: - Delegate methods
    
    func gabbPlayerUpdated() {
        playTime.text = gabber.playTime
        progressBar.setValue(gabber.episodeProgress, animated: true)
    }

}
