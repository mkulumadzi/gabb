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
    var audioPlaying:Bool = false

    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
        initializePlayer()
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
            if let url = NSURL(string: audioUrl) {
                player = AVPlayer(URL: url)
            }
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            return screenSize.width
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
            player.play()
            audioPlaying = true
        }
    }
    
    private func pauseEpisode() {
        if let playImage = UIImage(named: "play") {
            playButton.setImage(playImage, forState: .Normal)
        }
        if let player = player {
            player.pause()
            audioPlaying = false
        }
    }

}
