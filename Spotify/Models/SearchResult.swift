//
//  SearchResult.swift
//  Spotify
//
//  Created by Aruuke Turgunbaeva on 3/8/24.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
