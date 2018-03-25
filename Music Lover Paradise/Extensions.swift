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

extension UIView {
    func showActivityPanel(message: String) -> UIVisualEffectView {
        // Label Width
        let font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        let attributedString = NSAttributedString(string: message, attributes: [NSAttributedStringKey.font: font])
        let sizeToFit = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 46)
        let labelWidth = attributedString.boundingRect(with: sizeToFit, options: .usesLineFragmentOrigin, context: nil).width.rounded(.up)
        
        // Panel
        let panel = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        panel.translatesAutoresizingMaskIntoConstraints = false
        let panelHeight = panel.heightAnchor.constraint(equalToConstant: 46)
        let panelWidth = panel.widthAnchor.constraint(equalToConstant: 46 + labelWidth + 15)
        panel.addConstraints([panelHeight, panelWidth])
        panel.clipsToBounds = true
        panel.layer.cornerRadius = 9
        panel.tag = 300
        
        // Indicator
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        panel.contentView.addSubview(activityIndicator)
        
        // Label
        let label = UILabel(frame: CGRect(x: 46, y: 0, width: labelWidth, height: 46))
        label.text = message
        label.font = font
        label.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        panel.contentView.addSubview(label)
        
        // Show Panel
        if let superView = self.superview {
            for oldPanel in (superView.subviews.filter {$0.tag == 300}) {oldPanel.removeFromSuperview()}
            superView.addSubview(panel)
            let panelXCenter = panel.centerXAnchor.constraint(equalTo: superView.centerXAnchor)
            let panelYCenter = panel.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
            superView.addConstraints([panelXCenter, panelYCenter])
        }
        return panel
    }
}

extension TimeInterval {
    func stringFrom(interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: interval)!
    }
}

extension String {
    static var unknownText: String {
        return NSLocalizedString("Unknown", comment: "No data to show")
    }
    func parseDuration() -> TimeInterval {
        guard !self.isEmpty else {return 0}
        var interval:Double = 0
        
        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }

        return interval
    }
}

extension URL {
    static func discogs(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let searchTerm = String(format: "https://api.discogs.com/database/search?type=master&title=%@", encodedText)
        return URL(string: searchTerm + "&" + discogsKeySecret)!
    }
    static func discogs(resourceURL: String) -> URL {
        return URL(string: resourceURL + "?" + discogsKeySecret)!
    }
    static let discogsKeySecret = "key=ePhrcpQMVtEUrdiOPNgh&secret=DldGkZBXNumyRZfsPMXhjfhfjhSOuWSd"
}

extension Data {
    func parseTo<T: Codable>(jsonType: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(jsonType, from: self)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
}

extension UIScrollView {
    func resizeContentSize(offset: CGFloat = 15) {
        var contentRect = CGRect.zero
        let contentView = subviews[0]
        for view in contentView.subviews {contentRect = contentRect.union(view.frame)}
        contentSize = CGSize(width: contentSize.width, height: contentRect.size.height + offset)
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
