//
//  SettingsModels.swift
//  Spotify
//
//  Created by Aruuke Turgunbaeva on 27/7/24.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
