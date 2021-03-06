//
//  PlayerViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 12/05/2021.
//

import UIKit
import AVFoundation
import MediaPlayer

final class PlayerViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var songLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var timeSlider: UISlider!
    @IBOutlet private weak var likeButton: UIButton!
    
    private var selfListTrack = [Track]()
    private var playerProperty = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(imageUrl: playerProperty.imageUrlString, song: playerProperty.songName, artist: playerProperty.artist)
        if UserDefaults.standard.integer(forKey: "currentTrackId") != playerProperty.trackId {
            setupPlayer()
        } else {
            updateCurrentTime()
        }
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLikedStatus()
        PLayMusic.shared.isPlayerScreen = true
        PLayMusic.shared.configureTabBarPlayerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PLayMusic.shared.isPlayerScreen = false
        PLayMusic.shared.configureTabBarPlayerView()
    }
    
    private func configure() {
        view.backgroundColor = .white
        let imageViewRadius = imageView.width * 0.5
        imageView.layer.cornerRadius = imageViewRadius
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        let optionButton = UIBarButtonItem(image: UIImage(named: "option2"), style: .plain, target: self, action: #selector(didTapOptionButton))
        navigationItem.rightBarButtonItems = [optionButton]
        PLayMusic.shared.delegatePlayerScreen = self
        if PLayMusic.shared.player.rate != 0.0 && PLayMusic.shared.player.error == nil {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @objc private func didTapOptionButton() {
        let viewController = TrackAndPlaylistSettingViewController()
        viewController.getDataTrack(trackId: playerProperty.trackId, listTrack: selfListTrack)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func handleSliderChange() {
        guard let duration = PLayMusic.shared.player.currentItem?.asset.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        let currentSeconds = Double(timeSlider.value) * Double(durationSeconds)
        let timeScale = PLayMusic.shared.player.currentTime().timescale
        let currentTime = CMTime(seconds: currentSeconds, preferredTimescale: timeScale)
        PLayMusic.shared.player.seek(to: currentTime)
        PLayMusic.shared.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentSeconds
        MPNowPlayingInfoCenter.default().nowPlayingInfo = PLayMusic.shared.nowPlayingInfo
        
    }
    
    public func getData(track: Track, listTrack: [Track]) {
        selfListTrack = listTrack
        playerProperty.trackId = track.trackID ?? 0
        playerProperty.songName = track.title ?? ""
        playerProperty.imageUrlString = track.user?.avatarUrl ?? ""
        playerProperty.artist = track.user?.username ?? ""
    }
    
    private func loadData(imageUrl: String, song: String, artist: String) {
        imageView.loadImage(urlString: imageUrl)
        songLabel.text = song
        artistLabel.text = artist
        loadLikedStatus()
        title = song
        timeSlider.minimumTrackTintColor = .systemGreen
        timeSlider.value = 0
        timeSlider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
    }
    
    private func loadLikedStatus() {
        let listLikedTrackId = LikedTrackEntity.shared.getAllIdLikedTrack() ?? []
        playerProperty.isLiked = listLikedTrackId.contains(playerProperty.trackId)
        if playerProperty.isLiked {
            likeButton.setImage(UIImage(named: "likeHeart"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "unLikeHeart"), for: .normal)
        }
    }
    
    func secondsToMinutesSeconds (seconds: Float) -> String {
      return "\(Int(seconds) / 60):\(Int(seconds) % 60)"
    }
    
    private func setupPlayer() {
        PLayMusic.shared.preparePlayer(trackId: playerProperty.trackId, listTrack: selfListTrack)
        updateCurrentTime()
    }
    
    private func updateCurrentTime() {
        guard let playerItem = PLayMusic.shared.player.currentItem else { return }
        let duration = playerItem.asset.duration
        let durationSeconds = CMTimeGetSeconds(duration)
        let timeScale = PLayMusic.shared.player.currentTime().timescale
        let interval = CMTime(value: 1, timescale: timeScale)
        endTimeLabel.text = secondsToMinutesSeconds(seconds: Float(durationSeconds))
        PLayMusic.shared.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] (progressTime) in
            let currentTime = Float(CMTimeGetSeconds(progressTime))
            self?.currentTimeLabel.text = self?.secondsToMinutesSeconds(seconds: currentTime)
            self?.timeSlider.value = currentTime / Float(durationSeconds)
        }
    }
    
    @IBAction func playPauseButton(_ sender: UIButton) {
        if PLayMusic.shared.player.rate != 0.0 && PLayMusic.shared.player.error == nil {
            PLayMusic.shared.pasue()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            PLayMusic.shared.resume()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @IBAction func previousButton(_ sender: Any) {
        PLayMusic.shared.previous()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        PLayMusic.shared.next()
    }
    
    @IBAction func likedButton(_ sender: Any) {
        if playerProperty.isLiked {
            LikedTrackEntity.shared.deleteLikedTrack(trackId: playerProperty.trackId)
        } else {
            LikedTrackEntity.shared.insertNewLikedTrack(trackId: playerProperty.trackId)
        }
        DispatchQueue.main.async {
            self.loadLikedStatus()
        }
    }
}

extension PlayerViewController: PlayMusicDelegate {
    func reloadViewController(currentIndex: Int, listTrack: [Track]) {
        getData(track: listTrack[currentIndex], listTrack: listTrack)
        DispatchQueue.main.async {
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.loadData(imageUrl: self.playerProperty.imageUrlString,
                          song: self.playerProperty.songName,
                          artist: self.playerProperty.artist)
            self.setupPlayer()
        }
    }
}
