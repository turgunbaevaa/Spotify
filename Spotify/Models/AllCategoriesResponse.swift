//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by Aruuke Turgunbaeva on 3/8/24.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
    
}
   
        

