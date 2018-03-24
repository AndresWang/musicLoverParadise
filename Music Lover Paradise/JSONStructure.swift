//
//  JSON Structure.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

struct ResultArray: Codable {
    var results: [Result]!
}
struct Result: Codable {
    var title: String
    var year: String?
    var label: [String]
    var genre: [String]
    var thumb: String
    var cover_image: String
    var resource_url: String
}




