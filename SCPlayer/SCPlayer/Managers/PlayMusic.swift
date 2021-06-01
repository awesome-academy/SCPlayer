//
//  PlayMusic.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 26/05/2021.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol PlayMusicDelegate: class {
    func reloadViewController(currentIndex: Int, listTrack: [Track])
}

protocol PlayMusicForTabBarDelegate: class {
    func reloadViewController(currentIndex: Int, listTrack: [Track])
    func configureTabBarPlayerView()
}

class PLayMusic {
    
    var isPlayerScreen = false
    var selfListTrack = [Track]()
    var currentIndex = 0
    var player: AVPlayer
    var nowPlayingInfo = [String: Any]()
    weak var delegatePlayerScreen: PlayMusicDelegate?
    weak var delegateTabBar: PlayMusicForTabBarDelegate?
    
    static let shared = PLayMusic()
    
    private init() {
        player = AVPlayer.init()
    }
    
    func preparePlayer(trackId: Int, listTrack: [Track]) {
        UserDefaults.standard.setValue(trackId, forKey: "currentTrackId")
        selfListTrack = listTrack
        currentIndex = selfListTrack.firstIndex { return $0.trackID == trackId } ?? 0
        let streamUrl = selfListTrack[currentIndex].streamURL ?? ""
        initPlayer(streamUrl: streamUrl)
        delegateTabBar?.reloadViewController(currentIndex: currentIndex, listTrack: listTrack)
    }
    
    func initPlayer(streamUrl: String) {
        let urlString = "\(streamUrl)?client_id=\(APIKey.key.rawValue)"
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                guard let url = URL(string: urlString) else {
                    return
                }
                let playerItem = AVPlayerItem(url: url)
                player = AVPlayer.init(playerItem: playerItem)
                let durationSeconds = CMTimeGetSeconds(playerItem.asset.duration)
                setupMediaPlayer(durationSeconds: Int(durationSeconds))
                setUpRemoteTransparentControls()
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                       object: playerItem)
                player.play()
            } catch {
                print("AVAudioSession is not Active")
            }
        } catch {
            print("Can Not Play Background")
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        next()
    }
    
    func resume() {
        player.play()
    }

    func pasue() {
        player.pause()
    }
    
    func next() {
        guard currentIndex < selfListTrack.count - 1 else {
            return
        }
        currentIndex += 1
        preparePlayer(trackId: selfListTrack[currentIndex].trackID ?? 0, listTrack: selfListTrack)
        delegatePlayerScreen?.reloadViewController(currentIndex: currentIndex, listTrack: selfListTrack)
        delegateTabBar?.reloadViewController(currentIndex: currentIndex, listTrack: selfListTrack)
    }
    
    func previous() {
        guard currentIndex > 0 else {
            return
        }
        currentIndex -= 1
        preparePlayer(trackId: selfListTrack[currentIndex].trackID ?? 0, listTrack: selfListTrack)
        delegatePlayerScreen?.reloadViewController(currentIndex: currentIndex, listTrack: selfListTrack)
        delegateTabBar?.reloadViewController(currentIndex: currentIndex, listTrack: selfListTrack)
    }
    
    func configureTabBarPlayerView() {
        delegateTabBar?.configureTabBarPlayerView()
    }
    
    private func setupMediaPlayer(durationSeconds: Int) {
        if let imageUrl = selfListTrack[currentIndex].user?.avatarUrl {
            if let image = getImageFromUrl(urlString: imageUrl) {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                    return image
                }
            }
        }
        nowPlayingInfo[MPMediaItemPropertyArtist] = selfListTrack[currentIndex].user?.username ?? ""
        nowPlayingInfo[MPMediaItemPropertyTitle] = selfListTrack[currentIndex].title ?? ""
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationSeconds
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    
    }
    
    private func setUpRemoteTransparentControls () {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] _ in
            if self.player.rate == 0.0 && self.player.error == nil {
                self.player.play()
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            if self.player.rate != 0.0 && self.player.error == nil {
                self.player.pause()
            }
            return .commandFailed
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] _ in
            if self.player.rate != 0.0 && self.player.error == nil {
                self.next()
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] _ in
            if self.player.rate != 0.0 && self.player.error == nil {
                self.previous()
            }
            return .commandFailed
        }
    }
    
    private func getImageFromUrl(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}
