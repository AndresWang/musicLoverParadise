//
//  Music.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 30/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

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
        var artists: [JSON.Artist]!
        var tracklist: [JSON.Track]!
    }
}
