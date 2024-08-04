//
//  Artist.swift
//  Spotify
//
//  Created by Aruuke Turgunbaeva on 29/4/24.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
