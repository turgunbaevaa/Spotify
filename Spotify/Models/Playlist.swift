//
//  Playlist.swift
//  Spotify
//
//  Created by Aruuke Turgunbaeva on 29/4/24.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
