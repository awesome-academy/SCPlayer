//
//  PlayerViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 12/05/2021.
//

import UIKit
import AVFoundation

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
    }
    
    private func configure() {
        view.backgroundColor = .white
        let imageViewRadius = imageView.width * 0.5
        imageView.layer.cornerRadius = imageViewRadius
        navigationItem.largeTitleDisplayMode = .never
        if PLayMusic.shared.player.rate != 0.0 && PLayMusic.shared.player.error == nil {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @objc private func handleSliderChange() {
        guard let duration = PLayMusic.shared.player.currentItem?.asset.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        let currentSeconds = Double(timeSlider.value) * Double(durationSeconds)
        let currentTime = CMTime(seconds: currentSeconds, preferredTimescale: 1000000000)
        PLayMusic.shared.player.seek(to: currentTime)
    }
    
    public func getData(track: Track, listTrack: [Track]) {
        selfListTrack = listTrack
        playerProperty.trackId = track.trackID ?? 0
        playerProperty.songName = track.title ?? ""
        playerProperty.imageUrlString = track.user?.avatarUrl ?? ""
        playerProperty.artist = track.user?.username ?? ""
        playerProperty.streamUrl = "\(track.streamURL ?? "")?client_id=\(APIKey.key.rawValue)"
        playerProperty.trackIndex = listTrack.firstIndex { return ($0.trackID ?? 0) == playerProperty.trackId } ?? 0
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
        UserDefaults.standard.setValue(playerProperty.trackId, forKey: "currentTrackId")
        PLayMusic.shared.initPlay(streamUrl: playerProperty.streamUrl)
        guard let playerItem = PLayMusic.shared.player.currentItem else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        updateCurrentTime()
    }
    
    private func updateCurrentTime() {
        guard let playerItem = PLayMusic.shared.player.currentItem else { return }
        let duration = playerItem.asset.duration
        let durationSeconds = CMTimeGetSeconds(duration)
        let interval = CMTime(value: 1, timescale: 1000000000)
        endTimeLabel.text = secondsToMinutesSeconds(seconds: Float(durationSeconds))
        PLayMusic.shared.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] (progressTime) in
            let currentTime = Float(CMTimeGetSeconds(progressTime))
            self?.currentTimeLabel.text = self?.secondsToMinutesSeconds(seconds: currentTime)
            self?.timeSlider.value = currentTime / Float(durationSeconds)
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        guard playerProperty.trackIndex < selfListTrack.count - 1 else {
            return
        }
        getData(track: selfListTrack[playerProperty.trackIndex + 1], listTrack: selfListTrack)
        DispatchQueue.main.async {
            self.loadData(imageUrl: self.playerProperty.imageUrlString,
                          song: self.playerProperty.songName,
                          artist: self.playerProperty.artist)
        }
        setupPlayer()
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
        guard playerProperty.trackIndex > 0 else {
            return
        }
        getData(track: selfListTrack[playerProperty.trackIndex - 1], listTrack: selfListTrack)
        DispatchQueue.main.async {
            self.loadData(imageUrl: self.playerProperty.imageUrlString,
                          song: self.playerProperty.songName,
                          artist: self.playerProperty.artist)
            self.setupPlayer()
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        guard playerProperty.trackIndex < selfListTrack.count - 1 else {
            return
        }
        getData(track: selfListTrack[playerProperty.trackIndex + 1], listTrack: selfListTrack)
        DispatchQueue.main.async {
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.loadData(imageUrl: self.playerProperty.imageUrlString,
                          song: self.playerProperty.songName,
                          artist: self.playerProperty.artist)
            self.setupPlayer()
        }
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
