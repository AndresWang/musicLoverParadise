//
//  SearchResultCell.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var yearLabel: UILabel!
    @IBOutlet weak private var artworkImageView: UIImageView!
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = #colorLiteral(red: 0.9071379304, green: 0.2433879375, blue: 0.2114798129, alpha: 0.5)
        selectedBackgroundView = selectedView
    }
    
    // MARK:- Boundary Methods
    func configure(for result: Result) {
        titleLabel.text = result.title
        yearLabel.text = result.year ?? NSLocalizedString("Unknown", comment: "No year to show")
        artworkImageView.image = #imageLiteral(resourceName: "Placeholder")
        if let thumbURL = URL(string: result.thumb) {downloadTask = artworkImageView.loadImage(url: thumbURL)}
    }
}
