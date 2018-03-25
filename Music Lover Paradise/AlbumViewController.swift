//
//  AlbumViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 24/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet weak private var position: UILabel!
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var duration: UILabel!
}

class AlbumViewController: UIViewController {
    // Segue properties
    var coverImageURL = ""
    var albumYear = ""
    var albumGenre = ""
    var albumLabel = ""
    
    // IBOutlets
    @IBOutlet weak private var imageCover: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var artist: UIButton!
    @IBOutlet weak private var yearGenre: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var footerTrackTotal: UILabel!
    @IBOutlet weak private var footerLabel: UILabel!
    
    // Self properties
    var downloadCoverTask: URLSessionDownloadTask?
    var numberOfTracks = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.rowHeight = 44
        tableViewHeight.constant = CGFloat(44 * numberOfTracks)
        view.layoutIfNeeded()
        imageCover.rounded()
        if let coverURL = URL(string: coverImageURL) {downloadCoverTask = imageCover.loadImage(url: coverURL)}
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension AlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfTracks
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        return cell
    }
}
