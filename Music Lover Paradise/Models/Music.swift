//
//  Music.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 30/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// ATTENTION : This is the model object for our app, separated form json's object in case the json structure will change in the future (Or change of API).
struct Music {
    struct Result {
        var title: String
        var year: String?
        var thumb: String
        var cover_image: String
        var genre: [String]
        var label: [String]
        var resource_url: String
    }
    struct Album {
        var coverImageURL: String
        var year: String
        var genre: String
        var label: String
        var title: String
        var artists: [Artist]!
        var tracklist: [Track]!
    }
    struct Artist {
        var name: String
        var resource_url: String
    }
    struct Track {
        var duration: String
        var title: String
    }
    struct ArtistProfile {
        var profile: String
        var releases_url: String
        var name: String
        var images: [ArtistImage]?
        var urls: [String]?
        var primaryImage: String? {
            return images?.first?.uri
        }
    }
    struct ArtistImage {
        var uri: String
        var height: Int
        var width: Int
    }
}
