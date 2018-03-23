//
//  JSONStructure.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

struct ResultArray: Codable {
    var pagination: Pagination!
    var results: [SearchResult]!
}
struct Pagination: Codable {
    var items: Int
    var page: Int
    var pages: Int
    var per_page: Int
}
struct SearchResult: Codable {
    var cover_image: String
    var resource_url: String
    var thumb: String
    var title: String
}
