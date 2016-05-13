//
//  NowPlayingWidgetViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/9/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import MarqueeLabel_Swift

private let browseStoryboard = "Browse"
private let episodeViewController = "episodeViewController"

class NowPlayingWidgetViewController: UIViewController, GabbPlayerDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nowPlayingMarquee: MarqueeLabel!
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var episodeDuration: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = gabber {
            formatView()
        }
    }
    
    func formatView() {
        nowPlayingMarquee.textColor = UIColor.gabbLightGreyColor()
        
        if let podcastTitle = gabber.podcast.valueForKey("title") as? String {
            if let episodeTitle = gabber.episode.valueForKey("title") as? String {
                self.nowPlayingMarquee.text = podcastTitle + " - " + episodeTitle
            }
        }
        
        progressBar.setThumbImage(UIImage(), forState: .Normal)
        progressBar.minimumValue = 0.0
        progressBar.maximumValue = 100.0
        
        if gabber.playing {
            nowPlayingMarquee.restartLabel()
            showPauseButton()
        }
        else {
            nowPlayingMarquee.pauseLabel()
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
    
    @IBAction func overlayButtonTapped(sender: AnyObject) {
        guard let parent = parentViewController else {
            return
        }
        let vc = fetchViewController(browseStoryboard, storyboardIdentifier: episodeViewController) as! PlayEpisodeTableViewController
        vc.podcast = gabber.podcast
        vc.episode = gabber.episode
        vc.presentedModally = true
        parent.showViewController(vc, sender: parent)
    }
    
    // MARK: - Delegate methods
    
    func gabbPlayerUpdated() {
        playTime.text = gabber.playTime
        progressBar.setValue(gabber.episodeProgress, animated: true)
    }
    
    func played() {
        nowPlayingMarquee.unpauseLabel()
        showPauseButton()
    }
    
    func paused() {
        nowPlayingMarquee.pauseLabel()
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
