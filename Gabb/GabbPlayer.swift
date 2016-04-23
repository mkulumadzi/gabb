//
//  GabbPlayer.swift
//  Gabb
//
//  Created by Evan Waters on 4/8/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

protocol GabbPlayerDelegate {
    func gabbPlayerUpdated()
    func played()
    func paused()
}

class GabbPlayer: NSObject {
    
    var podcast:NSDictionary!
    var episode:NSDictionary!
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
    
    init (podcast: NSDictionary, episode: NSDictionary) {
        super.init()
        self.podcast = podcast

        if let audioUrl = episode.valueForKey("audio_url") as? String {
            if let url = NSURL(string: audioUrl) {
                self.episode = episode
                self.audioUrl = audioUrl
                self.player = AVPlayer(URL: url)
                self.asset = AVURLAsset(URL: url, options: nil)
                self.audioPlaying = false
            }
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
        
        if currentUser != nil { SessionService.startSession(self) }
        
        updater = CADisplayLink(target: self, selector: #selector(GabbPlayer.updateDelegate))
        updater.frameInterval = 1
        updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        player.play()
        delegate?.played()
    }
    
    func pause() {
        guard let player = self.player, updater = self.updater else {
            return
        }
        
        if currentUser != nil { SessionService.stopSession(self) }
        
        player.pause()
        delegate?.paused()
        updater.invalidate()
    }
    
    func updateDelegate() {
        delegate?.gabbPlayerUpdated()
    }
    
    func getLastSession(completionHandler: () -> Void) {
        SessionService.getLastSessionForEpisode(audioUrl, completion: { (result) -> Void in
            if let result = result {
                let json = JSON(result)
                let stopTimeScale = json["stop_time_scale"].int32Value
                let stopTimeValue = json["stop_time_value"].int64Value
                if stopTimeScale > 0 && stopTimeValue > 0 {
                    let stopTime = CMTime(value: stopTimeValue, timescale: stopTimeScale)
                    self.player.seekToTime(stopTime)
                    completionHandler()
                } else {
                    completionHandler()
                }
            } else {
                completionHandler()
            }
        })
    }

}
