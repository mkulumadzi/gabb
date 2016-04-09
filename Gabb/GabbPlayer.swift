//
//  GabbPlayer.swift
//  Gabb
//
//  Created by Evan Waters on 4/8/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import AVFoundation

protocol GabbPlayerDelegate {
    func gabbPlayerUpdated()
}

class GabbPlayer: NSObject {
    
    var audioUrl:String!
    var player:AVPlayer!
    var asset:AVURLAsset!
    var audioPlaying:Bool!
    var duration:NSString!
    var updater:CADisplayLink!
    
    var delegate:GabbPlayerDelegate?
    
    private var _episodeDuration:String!
    private var _playTime:String!
    private var _episodeProgress:Float!
    private var _playing:Bool!
    
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
    
    var playing: Bool {
        guard let player = self.player else {
            _playing = false
            return false
        }
        _playing = player.rate > 0 ? true : false
        return _playing
    }
    
    func play() {
        guard let player = self.player else {
            return
        }
        updater = CADisplayLink(target: self, selector: #selector(GabbPlayer.updateDelegate))
        updater.frameInterval = 1
        updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        player.play()
    }
    
    func pause() {
        guard let player = self.player, updater = self.updater else {
            return
        }
        player.pause()
        updater.invalidate()
    }
    
    func updateDelegate() {
        delegate?.gabbPlayerUpdated()
    }

}