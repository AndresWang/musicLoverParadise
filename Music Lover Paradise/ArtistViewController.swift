//
//  ArtistViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 25/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController {
    // Segue properties
    var artistProfile: Music.ArtistProfile?
    
    // IBOutlets
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var photo: UIImageView!
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var profile: UILabel!
    
    // Self Properties
    private var downloadCoverTask: URLSessionDownloadTask?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        if let imageURLString = artistProfile?.primaryImage, let url = URL(string: imageURLString) {
            downloadCoverTask = photo.loadImage(url: url)
        } else {
            photo.image = #imageLiteral(resourceName: "noImage")
        }
        name.text = artistProfile?.name
        profile.text = artistProfile?.profile
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {self.scrollView.resizeContentSize()}
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        downloadCoverTask?.cancel()
    }
}
