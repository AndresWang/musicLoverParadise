//
//  JSON Structure.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

struct ResultArray: Codable {
    var results: [Result]!
}
struct Result: Codable {
    var title: String
    var year: String?
    var thumb: String
    var cover_image: String
    var genre: [String]
    var label: [String]
    var resource_url: String
}
struct AlbumDetail: Codable {
    var title: String
    var artists: [Artist]!
    var tracklist: [Track]!
}
struct Artist: Codable {
    var name: String
    var resource_url: String
}
struct Track: Codable {
    var duration: String
    var title: String
}
struct ArtistProfile: Codable {
    var profile: String
    var releases_url: String
    var name: String
    var images: [ArtistImage]?
    var urls: [String]?
    var primaryImage: String? {
        return images?.first?.uri
    }
}
struct ArtistImage: Codable {
    var uri: String
    var height: Int
    var width: Int
}




