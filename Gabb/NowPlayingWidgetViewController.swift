//
//  NowPlayingWidgetViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/9/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class NowPlayingWidgetViewController: UIViewController, GabbPlayerDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var episodeDuration: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
    }
    
    func formatView() {
        nowPlayingLabel.textColor = UIColor.gabbLightGreyColor()
        
        if let podcastTitle = gabber.podcast.valueForKey("title") as? String {
            if let episodeTitle = gabber.episode.valueForKey("title") as? String {
                self.nowPlayingLabel.text = podcastTitle + " - " + episodeTitle
            }
        }
        
        progressBar.setThumbImage(UIImage(), forState: .Normal)
        progressBar.minimumValue = 0.0
        progressBar.maximumValue = 100.0
        
        if gabber.playing {
            showPauseButton()
        }
        else {
            showPlayButton()
        }
        
        episodeDuration.text = gabber.episodeDuration
    }
    
    // MARK: - User actions
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        if !gabber.playing {
            gabber.play()
        }
        else {
            gabber.pause()
        }
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
