//
//  PlayEpisodeTableViewController.swift
//  Gabb
//
//  Created by Evan Waters on 3/27/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

private let noState = -1
private let wasPlaying = 0
private let wasNotPlaying = 1

class PlayEpisodeTableViewController: UITableViewController, GabbPlayerDelegate {
    
    var podcast:NSDictionary!
    var episode:NSDictionary!
    
    var gabbQueue:GabbPlayer!
    
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var episodeDuration: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        formatView()
        checkGabberStatus()
        super.viewDidLoad()
    }
    
    func formatView() {
        
        if let image = podcast["image"] as? UIImage {
            self.podcastImageView.image = image
        }
        
        if let podcastTitle = podcast.valueForKey("title") as? String {
            self.podcastTitle.text = podcastTitle
        }
        if let episodeTitle = episode.valueForKey("title") as? String {
            self.episodeTitle.text = episodeTitle
        }
        
        progressBar.minimumValue = 0
        progressBar.maximumValue = 100
        progressBar.tag = noState
        
        tableView.tableHeaderView = UIView(frame: CGRectMake(0,0,screenSize.width,0.1))
    }
    
    /*
     If player is not playing, initialize it
     If player is playing this episode, start updating the view
     If player is playing another episode, initialize the view but do not start playing
    */
    
    func checkGabberStatus() {
        guard let gabber = gabber else {
            initializePlayer()
            return
        }
        
        if gabber.audioUrl == episode["audio_url"] as? String {
            gabber.delegate = self
            if gabber.playing {
                showPauseButton()
            }
            else {
                progressBar.setValue(gabber.episodeProgress, animated: false)
                showPlayButton()
            }
        }
        else {
            showPlayButton()
            queueUpEpisode()
        }
    }
    
    func initializePlayer() {
        print("Starting the player at \(NSDate())")
        if let audioUrl = episode["audio_url"] as? String {
            gabber = GabbPlayer(audioUrl: audioUrl)
            gabber.delegate = self
            episodeDuration.text = gabber.episodeDuration
            playTime.text = gabber.playTime
            progressBar.setValue(0, animated: false)
        }
        print("Finished starting the player at \(NSDate())")
    }
    
    func queueUpEpisode() {
        print("Starting the player at \(NSDate())")
        if let audioUrl = episode["audio_url"] as? String {
            gabbQueue = GabbPlayer(audioUrl: audioUrl)
            gabbQueue.delegate = self
            episodeDuration.text = gabbQueue.episodeDuration
            playTime.text = gabbQueue.playTime
            progressBar.setValue(0, animated: false)
        }
        print("Finished starting the player at \(NSDate())")
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
            return 66.0
        case 2:
            return 96.0
        default:
            return 66.0
        }
    }
    
    // MARK: - User Actions
    
    //If another episode is playing, stop it, kill that player, and assign the player to this episode. Then play it.
    // If another episode is not playing, just play this episode
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        if !gabber.playing {
            gabber.play()
        }
        else if (gabber.audioUrl != episode["audio_url"] as? String) {
            gabber.pause()
            gabber = gabbQueue
            gabber.play()
        }
        else {
            gabber.pause()
        }
    }
    
    /*
     If this is the first time this function was called, pause the player (if necessary) and records its state (playing or not playing)
     Set the time labels based on the position of the slider.
    */
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        if gabber.playing {
            gabber.pause()
            progressBar.tag = wasPlaying
        }
        else if progressBar.tag == noState {
            progressBar.tag = wasNotPlaying
        }
        let newTime = getTimeFromProgressBar()
        playTime.text = newTime.toString()
    }
    
    @IBAction func sliderEditingEnded(sender: AnyObject) {
        let newTime = getTimeFromProgressBar()
        gabber.player.seekToTime(newTime)
        if progressBar.tag == wasPlaying {
            gabber.play()
        }
        progressBar.tag = -1
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
    
    func played() {
        showPauseButton()
    }
    
    func paused() {
        showPlayButton()
    }
    
    // MARK: - Private
    
    private func showPlayButton() {
        if let playImage = UIImage(named: "play") {
            playButton.setImage(playImage, forState: .Normal)
        }
    }
    
    private func showPauseButton() {
        if let pauseImage = UIImage(named: "pause") {
            playButton.setImage(pauseImage, forState: .Normal)
        }
    }

}
