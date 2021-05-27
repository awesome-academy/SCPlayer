//
//  PlayMusic.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 26/05/2021.
//

import Foundation
import AVFoundation

class PLayMusic {
    
    var player: AVPlayer
    
    static let shared = PLayMusic()
    
    private init() {
        player = AVPlayer.init()
    }
    
    func initPlay(streamUrl: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                guard let url = URL(string: streamUrl) else {
                    return
                }
                let playerItem = AVPlayerItem(url: url)
                player = AVPlayer.init(playerItem: playerItem)
                player.play()
            } catch {
                print("AVAudioSession is not Active")
            }
        } catch {
            print("Can Not Play Background")
        }
    }
    
    func resume() {
        player.play()
    }

    func pasue() {
        player.pause()
    }
}
