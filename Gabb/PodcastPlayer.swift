//
//  PodcastPlayer.swift
//  Gabb
//
//  Created by Evan Waters on 4/8/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import AVFoundation

class PodcastPlayer: NSObject {
    
    var audioUrl:String!
    var player:AVPlayer!
    var asset:AVURLAsset!
    var audioPlaying:Bool!
    var duration:NSString!
    
    private var _episodeDuration:String!
    private var _playTime:String!
    private var _episodeProgress:Float!
    
    
    init (audioUrl: String) {
        if let url = NSURL(string: audioUrl) {
            self.audioUrl = audioUrl
            self.player = AVPlayer(URL: url)
            self.asset = AVURLAsset(URL: url, options: nil)
            self.audioPlaying = false
        }
    }
    
    var episodeDuration: String {
        _episodeDuration = self.asset.duration.toString()
        return _episodeDuration
    }
    
    var playTime: String {
        _playTime = self.player.currentTime().toString()
        return _playTime
    }
    
    var episodeProgress: Float {
        _episodeProgress = Float(CMTimeGetSeconds(self.player.currentTime()) / CMTimeGetSeconds(self.asset.duration)) * 100
        return _episodeProgress
    }

}
