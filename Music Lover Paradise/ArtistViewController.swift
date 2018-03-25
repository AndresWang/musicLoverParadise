//
//  ArtistViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 25/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController {
    // Properties for Segue
    var artistProfile: ArtistProfile?
    
    // IBOutlets
    @IBOutlet weak private var photo: UIImageView!
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var profile: UILabel!
    
    // Private Properties
    var downloadCoverTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURLString = artistProfile?.primaryImage, let url = URL(string: imageURLString) {
            downloadCoverTask = photo.loadImage(url: url)
        }
        name.text = artistProfile?.name
        profile.text = artistProfile?.profile
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        downloadCoverTask?.cancel()
    }
}
