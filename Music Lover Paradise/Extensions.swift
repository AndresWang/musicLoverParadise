//
//  Extensions.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

func < (lhs: Result, rhs: Result) -> Bool {
    return lhs.title.localizedCompare(rhs.title) == .orderedAscending
}

extension URL {
    static func discogs(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://api.discogs.com/database/search?format=album&type=release&release_title=%@&key=ePhrcpQMVtEUrdiOPNgh&secret=DldGkZBXNumyRZfsPMXhjfhfjhSOuWSd", encodedText)
        return URL(string: urlString)!
    }
    func requestData() -> Data? {
        do {
            return try Data(contentsOf: self)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            return nil
        }
    }
}

extension Data {
    func parseToResults() -> [Result] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: self)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}
