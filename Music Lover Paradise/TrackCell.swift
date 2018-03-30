//
//  TrackCell.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 30/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet weak private var position: UILabel!
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var duration: UILabel!
    
    func configure(with track: Music.Track, row: Int) {
        position.text = "\(row)"
        name.text = track.title
        duration.text = track.duration
    }
}
