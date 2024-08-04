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
        else if let player = self.playerQueue, !tracks.isEmpty {
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
        player?.volume = 0.0
        
        self.track = track
        self.tracks = []
        
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
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap { item in
            guard let url = URL(string: item.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        })
        
        self.playerQueue?.volume = 0
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
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            //Not playlist or album
            player?.pause()
        }
        else if let player = playerQueue  {
            playerQueue?.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            //Not playlist or album
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first{
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
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

