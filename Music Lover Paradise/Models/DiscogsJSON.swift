//
//  DiscogsJSON.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

struct JSON {
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
        
        func toMusic() -> Music.Result {
            return Music.Result(title: title, year: year, thumb: thumb, cover_image: cover_image, genre: genre, label: label, resource_url: resource_url)
        }
    }
    struct Album: Codable {
        var title: String
        var artists: [Artist]!
        var tracklist: [Track]!
        
        func toMusic(coverImageURL: String, year: String, genre: String, label: String) -> Music.Album {
            return Music.Album(coverImageURL: coverImageURL, year: year, genre: genre, label: label, title: title, artists: artists.map{$0.toMusic()}, tracklist: tracklist.map{$0.toMusic()})
        }
    }
    struct Artist: Codable {
        var name: String
        var resource_url: String
        
        func toMusic() -> Music.Artist {
            return Music.Artist(name: name, resource_url: resource_url)
        }
    }
    struct Track: Codable {
        var duration: String
        var title: String
        
        func toMusic() -> Music.Track {
            return Music.Track(duration: duration, title: title)
        }
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
        
        func toMusic() -> Music.ArtistProfile {
            return Music.ArtistProfile(profile: profile, releases_url: releases_url, name: name, images: images?.map{$0.toMusic()}, urls: urls)
        }
    }
    struct ArtistImage: Codable {
        var uri: String
        var height: Int
        var width: Int
        
        func toMusic() -> Music.ArtistImage {
            return Music.ArtistImage(uri: uri, height: height, width: width)
        }
    }
}





