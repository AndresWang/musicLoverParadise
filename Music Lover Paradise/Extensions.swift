//
//  Extensions.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

func > (lhs: Result, rhs: Result) -> Bool {
    let lhsYear = Int(lhs.year ?? "0") ?? 0
    let rhsYear = Int(rhs.year ?? "0") ?? 0
    return lhsYear > rhsYear
}

extension UIViewController {
    func showNetworkError() {
        let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "Network error title"), message: NSLocalizedString("There was an error accessing Discogs database. Please try again", comment: "Network error message"), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm Button"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension String {
    static func unknownText() -> String {
        return NSLocalizedString("Unknown", comment: "No data to show")
    }
}

extension URL {
    static func discogs(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let searchTerm = String(format: "https://api.discogs.com/database/search?type=master&title=%@", encodedText)
        return URL(string: searchTerm + discogsKeySecret)!
    }
    static let discogsKeySecret = "&key=ePhrcpQMVtEUrdiOPNgh&secret=DldGkZBXNumyRZfsPMXhjfhfjhSOuWSd"
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

extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] localURL, response, error in
            if error == nil, let localURL = localURL, let data = try? Data(contentsOf: localURL), let image = UIImage(data: data) {
                DispatchQueue.main.async {if let weakSelf = self {weakSelf.image = image}}
            } else {
                print("Something wrong with downloading the image")
            }
        }
        downloadTask.resume()
        return downloadTask
    }
    func rounded() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
}
