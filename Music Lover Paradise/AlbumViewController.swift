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
    
    func configure(with track: Track, row: Int) {
        position.text = "\(row)"
        name.text = track.title
        duration.text = track.duration
    }
}

class AlbumViewController: UIViewController {
    // Segue properties
    var coverImageURL = ""
    var albumYear = ""
    var albumGenre = ""
    var albumLabel = ""
    var album: AlbumDetail?
    
    // IBOutlets
    @IBOutlet weak private var scrollView: UIScrollView!
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
    var loadArtistTask: URLSessionDataTask?
    var activityView: UIVisualEffectView?
    
    // IBActions
    @IBAction func artistPressed(_ sender: Any) {
        loadArtistTask?.cancel()
        activityView = view.showActivityPanel(message: NSLocalizedString("Loading...", comment: "Network working"))
        if let artistURL = album?.artists.first?.resource_url {
            loadArtist(artistURL: artistURL)
        } else {
            showNetworkError()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.rowHeight = 44
        tableViewHeight.constant = CGFloat(44 * (album?.tracklist.count ?? 0))
        imageCover.rounded()
        if let coverURL = URL(string: coverImageURL) {downloadCoverTask = imageCover.loadImage(url: coverURL)}
        updateUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {self.scrollView.resizeContentSize()}
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SearchViewController {
            downloadCoverTask?.cancel()
            loadArtistTask?.cancel()
        } else /* Artist view */ {
            
        }
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        titleLabel.text = album?.title
        artist.setTitle(album?.artists.first?.name, for: UIControlState())
        yearGenre.text = "\(albumYear) \(albumGenre)"
        tableView.reloadData()
        let songsText = String(format: NSLocalizedString("%li Songs", comment: "Number of songs"), album?.tracklist.count ?? 0)
        footerTrackTotal.text = "\(songsText), \(totalDuration())"
        footerLabel.text = "℗" + albumLabel
    }
    private func totalDuration() -> String {
        guard let list = album?.tracklist else {print("Calculation Failure: No Track List!") ; return String.unknownText }
        var duration: TimeInterval = 0
        for track in list {
            duration += track.duration.parseDuration()
        }
        return duration.stringFrom(interval: duration)
    }
    private func loadArtist(artistURL: String) {
        let session = URLSession.shared
        loadArtistTask = session.dataTask(with: URL.discogs(resourceURL: artistURL)) { data, response, error in
            DispatchQueue.main.async {
                self.activityView?.removeFromSuperview()
                self.activityView = nil
            }
            
            if let error = error as NSError?, error.code == -999 {
                return // Task was cancelled
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    self.album = data.parseTo(jsonType: AlbumDetail.self)
                    DispatchQueue.main.async {self.performSegue(withIdentifier: "ArtistSegue", sender: self)}
                    return // Exit the closure
                }
            } else {
                print("URLSession Failure! \(String(describing: response))")
            }
            
            // Handle errors
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showNetworkError()
            }
        }
        loadArtistTask?.resume()
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension AlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album?.tracklist.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        
        guard let hasTrackList = album?.tracklist else {return cell}
        let row = indexPath.row
        let track = hasTrackList[row]
        cell.configure(with: track, row: row + 1)
        return cell
    }
}
