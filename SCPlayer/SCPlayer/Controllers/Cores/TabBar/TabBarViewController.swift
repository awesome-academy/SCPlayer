//
//  TabBarViewController.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 10/05/2021.
//

import UIKit
import SnapKit
import AVFoundation

final class TabBarViewController: UITabBarController {
    
    private var selfListTrack = [Track]()
    private var trackIndex = 0
    
    private let playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let songLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19.0)
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "next2"), for: .normal)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progressTintColor = .systemGreen
        progressView.trackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTabBar()
        getDataFromAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configurePlayerView()
    }
    
    private func configure() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapPlayerView))
        self.playerView.addGestureRecognizer(gesture)
    }
    
    private func configurePlayerView() {
        view.addSubview(playerView)
        view.addSubview(progressView)
        playerView.addSubview(imageView)
        playerView.addSubview(songLabel)
        playerView.addSubview(timeLabel)
        playerView.addSubview(playPauseButton)
        playerView.addSubview(nextButton)
        let scale: CGFloat = view.height / 896.0
        let playerViewYOrigin = view.bottom - 80 * scale - 80
        
        playerView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.width, height: 80))
            make.centerX.equalTo(view)
            make.top.equalTo(playerViewYOrigin)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.left.equalTo(0)
            make.centerY.equalTo(playerView)
            
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.right.equalTo(nextButton.snp.left).offset(-30)
            make.centerY.equalTo(playerView)
        }
        
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 26))
            make.right.equalTo(playerView.snp.right).offset(-30)
            make.centerY.equalTo(playerView)
        }
        
        songLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(playPauseButton.snp.left).offset(-30)
            make.top.equalTo(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(30)
            make.right.equalTo(playPauseButton.snp.left).offset(-30)
            make.top.equalTo(songLabel.snp.bottom).offset(10)
        }
        
        progressView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.width, height: 2))
            make.centerX.equalTo(view)
            make.top.equalTo(playerView.snp.bottom)
        }
    }
    
    private func initPlayer() {
        let trackId = UserDefaults.standard.integer(forKey: "currentTrackId")
        trackIndex = selfListTrack.firstIndex { return $0.trackID == trackId } ?? 0
        PLayMusic.shared.preparePlayer(trackId: selfListTrack[trackIndex].trackID ?? 0, listTrack: selfListTrack)
        PLayMusic.shared.delegateTabBar = self
        reloadPlayerView(track: selfListTrack[trackIndex])
        updateProgress()
    }
    
    private func updateProgress() {
        guard let duration = PLayMusic.shared.player.currentItem?.asset.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        let timeScale = PLayMusic.shared.player.currentTime().timescale
        let interval = CMTime(value: 1, timescale: timeScale)
        let durationString = secondsToMinutesSeconds(seconds: Float(durationSeconds))
        PLayMusic.shared.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] (currentTime) in
            let currentTimeSeconds = CMTimeGetSeconds(currentTime)
            let progress = currentTimeSeconds / durationSeconds
            self?.progressView.setProgress(Float(progress), animated: true)
            if let secondString = self?.secondsToMinutesSeconds(seconds: Float(currentTimeSeconds)) {
                self?.timeLabel.text = "\(secondString)        -        \(durationString)"
            }
            
        }
    }
    
    private func secondsToMinutesSeconds(seconds: Float) -> String {
      return "\(Int(seconds) / 60):\(Int(seconds) % 60)"
    }
    
    private func getDataFromAPI() {
        APIServices.shared.fetchTracksJSON { [unowned self] result in
            switch result {
            case .success(let tracks):
                self.selfListTrack = tracks
                DispatchQueue.main.async {
                    self.initPlayer()
                }
            case .failure(let error):
                print("Failed to fetch Tracks: \(error)")
            }
        }
    }
    
    private func reloadPlayerView(track: Track) {
        imageView.loadImage(urlString: track.user?.avatarUrl)
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        songLabel.text = track.title ?? ""
    }
    
    private func configureTabBar() {
        view.backgroundColor = .white
        viewControllers = [
            configChildNavigationController(viewController: HomeViewController(), item: TabbarItem.home.item),
            configChildNavigationController(viewController: SearchViewController(), item: TabbarItem.search.item),
            configChildNavigationController(viewController: LibraryViewController(), item: TabbarItem.library.item)
        ]
    }
    
    private func configChildNavigationController(viewController: UIViewController, item: UITabBarItem) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = item
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
    
    @objc private func didTapPlayerView() {
        let viewController = PlayerViewController()
        viewController.getData(track: selfListTrack[trackIndex], listTrack: selfListTrack)
        present(viewController, animated: true, completion: nil)
    }
    
    @objc private func didTapPlayPauseButton() {
        if PLayMusic.shared.player.rate != 0 && PLayMusic.shared.player.error == nil {
            PLayMusic.shared.pasue()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            PLayMusic.shared.resume()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @objc private func didTapNextButton() {
        PLayMusic.shared.next()
    }
}

extension TabBarViewController: PlayMusicForTabBarDelegate {
    func configureTabBarPlayerView() {
        DispatchQueue.main.async {
            self.playerView.isHidden = PLayMusic.shared.isPlayerScreen
            self.progressView.isHidden = PLayMusic.shared.isPlayerScreen
        }
    }
    
    func reloadViewController(currentIndex: Int, listTrack: [Track]) {
        trackIndex = currentIndex
        selfListTrack = listTrack
        DispatchQueue.main.async {
            self.reloadPlayerView(track: self.selfListTrack[currentIndex])
            self.updateProgress()
        }
    }
}
