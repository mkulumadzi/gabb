//
//  PlayEpisodeViewController.swift
//  Gabb
//
//  Created by Evan Waters on 5/13/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

private let noState = -1
private let wasPlaying = 0
private let wasNotPlaying = 1

class PlayEpisodeViewController: UIViewController, GabbPlayerDelegate {

    var podcast:NSDictionary!
    var episode:NSDictionary!
    var presentedModally:Bool = false
    
    var gabbQueue:GabbPlayer!
    
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var episodeDuration: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkGabberStatus()
    }
    
    func formatView() {
        
        self.edgesForExtendedLayout = .Top
        
        activityIndicator.startAnimating()
        playButton.hidden = true
        
        if let image = podcast["image"] as? UIImage {
            self.podcastImageView.image = image
        } else if let imageUrl = podcast["image_url"] as? String {
            getPodcastImage(imageUrl)
        }
        
        if let podcastTitle = podcast.valueForKey("title") as? String {
            self.podcastTitle.text = podcastTitle
        }
        if let episodeTitle = episode.valueForKey("title") as? String {
            self.episodeTitle.text = episodeTitle
        }
        
        if let image = UIImage(named: "sliderBar") {
            progressBar.setThumbImage(image, forState: .Normal)
        }
        
        playTime.text = "0:00"
        episodeDuration.text = "0:00"
        
        progressBar.minimumValue = 0
        progressBar.maximumValue = 100
        progressBar.tag = noState
        progressBar.enabled = false
        
        playButton.enabled = false
        
        edgesForExtendedLayout = .Top
        extendedLayoutIncludesOpaqueBars = true
        
        let backbarPosition = CGPoint(x: 20, y: 20)
        if let backgroundColor = podcastImageView.image?.getPixelColor(backbarPosition) {
            navigationController?.navigationBar.tintColor = UIColor.readableColorForBackground(backgroundColor)
        }
        else {
            navigationController?.navigationBar.tintColor = UIColor.gabbRedColor()
        }
        
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    // This is redundant - doing this on the 'browse' screen too.
    func getPodcastImage(imageURL: String) {
        FileService.getFullImageForURL(imageURL, completion: {(image) -> Void in
            if let image = image {
                self.podcastImageView.image = image
            }
        })
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
            if let main = navigationController?.parentViewController as? MainViewController {
                main.hideNowPlayingWidget()
            }
            
            gabber.delegate = self
            if gabber.playing {
                showPauseButton()
            }
            else {
                progressBar.setValue(gabber.episodeProgress, animated: false)
                showPlayButton()
            }
            layoutViewForGabbPlayer(gabber)
        }
        else {
            
            showPlayButton()
            queueUpEpisode()
        }
    }
    
    func initializePlayer() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            gabber = GabbPlayer(podcast: self.podcast, episode: self.episode)
            gabber.getLastSession({() -> Void in
                self.layoutViewForGabbPlayer(gabber)
            })
        }
    }
    
    func queueUpEpisode() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.gabbQueue = GabbPlayer(podcast: self.podcast, episode: self.episode)
            self.gabbQueue.getLastSession({() -> Void in
                self.layoutViewForGabbPlayer(self.gabbQueue)
            })
        }
    }
    
    func layoutViewForGabbPlayer(gabbPlayer: GabbPlayer) {
        gabbPlayer.delegate = self
        episodeDuration.text = gabbPlayer.episodeDuration
        playTime.text = gabbPlayer.playTime
        playButton.hidden = false
        playButton.enabled = true
        progressBar.enabled = true
        progressBar.setValue(gabbPlayer.episodeProgress, animated: false)
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: - User Actions
    
    //If another episode is playing, stop it, kill that player, and assign the player to this episode. Then play it.
    // If another episode is not playing, just play this episode
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        if !gabber.playing && gabbQueue == nil {
            gabber.play()
        } else if !gabber.playing && gabbQueue != nil {
            gabber = gabbQueue
            gabbQueue = nil
            gabber.play()
        }
        else if gabber.playing && gabbQueue != nil {
            gabber.pause()
            gabber = gabbQueue
            gabbQueue = nil
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let main = navigationController?.parentViewController as? MainViewController {
            main.toggleNowPlayingWidget()
        }
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
