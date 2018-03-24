//
//  JSON Structure.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

struct ResultArray: Codable {
    var pagination: Pagination!
    var results: [Result]!
}
struct Pagination: Codable {
    var items: Int
    var page: Int
    var pages: Int
    var per_page: Int
}
struct Result: Codable {
    var title: String
    var resource_url: String
    var cover_image: String
    var thumb: String
    var year: String?
}
struct Release: Codable {
    var artists_sort: String
}




