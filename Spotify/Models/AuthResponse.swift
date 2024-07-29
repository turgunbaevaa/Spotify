//
//  AuthResponse.swift
//  Spotify
//
//  Created by Aruuke Turgunbaeva on 30/6/24.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
