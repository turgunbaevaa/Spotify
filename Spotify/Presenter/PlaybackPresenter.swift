//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Aruuke Turgunbaeva on 4/8/24.
//

import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var index = 0
    
    var currenttrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if !tracks.isEmpty, index < tracks.count {
            return tracks[index]
        }
        return nil
    }
    
    var playerVC: PlayerViewController?
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    func startPlayback(from viewController: UIViewController,
                              track: AudioTrack) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        self.track = track
        self.tracks = []
        self.index = 0
        
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    func startPlayback(from viewController: UIViewController,
                              tracks: [AudioTrack]) {
        self.tracks = tracks
        self.track = nil
        self.index = 0
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap { item in
            guard let url = URL(string: item.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        })
        
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    
    func didTapPlayPause() {
        DispatchQueue.main.async {
            if let player = self.player {
                if player.timeControlStatus == .playing {
                    player.pause()
                }
                else if player.timeControlStatus == .paused {
                    player.play()
                }
            }
            else if let player = self.playerQueue {
                if player.timeControlStatus == .playing {
                    player.pause()
                }
                else if player.timeControlStatus == .paused {
                    player.play()
                }
            }
        }
    }
    
    func didTapForward() {
        DispatchQueue.main.async {
            if self.tracks.isEmpty {
                self.player?.pause()
            } else if let player = self.playerQueue, self.index < self.tracks.count - 1 {
                self.index += 1
                player.advanceToNextItem()
                self.playerVC?.refreshUI()
            } else {
                // Handle end of the track list
                self.playerQueue?.pause()
            }
        }
    }
    
    func didTapBackward() {
        DispatchQueue.main.async {
            if self.tracks.isEmpty {
                self.player?.seek(to: CMTime.zero)
                self.player?.play()
            } else if self.index > 0 {
                self.index -= 1
                let item = AVPlayerItem(url: URL(string: self.tracks[self.index].preview_url ?? "")!)
                self.playerQueue?.insert(item, after: nil)
                self.playerQueue?.advanceToNextItem()
                self.playerVC?.refreshUI()
            } else {
                // Restart the first track
                self.playerQueue?.seek(to: CMTime.zero)
                self.playerQueue?.play()
            }
        }
    }
    
    func didSlideSlider(_ value: Float) {
        DispatchQueue.main.async {
            self.player?.volume = value
            self.playerQueue?.volume = value
        }
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currenttrack?.name
    }
    
    var subtitle: String? {
        return currenttrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currenttrack?.album?.images.first?.url ?? "")
    }
}

