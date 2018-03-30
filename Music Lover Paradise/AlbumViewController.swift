//
//  AlbumViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 24/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, ActivityIndicatable {
    private let interactor: AlbumInteractorDelegate = AlbumInteractor()
    private var downloadCoverTask: URLSessionDownloadTask?
    var activityView: UIVisualEffectView?
    
    // IBOutlets
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var imageCover: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var artist: UIButton!
    @IBOutlet weak private var yearGenre: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var footerTrackTotal: UILabel!
    @IBOutlet weak private var footerLabel: UILabel!
    
    // IBActions
    @IBAction func artistPressed(_ sender: Any) {
        activityView = view.showActivityPanel(message: NSLocalizedString("Loading...", comment: "Network working"))
        if let artistURL = interactor.album.artists.first?.resource_url {
            interactor.loadArtist(with: artistURL, prehandler: stopActivityIndicator, dataHandler: loadArtistDataHandler(_:), errorHandler: loadArtistErrorHandler)
        } else {
            stopActivityIndicator()
            showNetworkError()
        }
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.rowHeight = 44
        tableViewHeight.constant = CGFloat(44 * (interactor.album.tracklist.count))
        imageCover.rounded()
        if let coverURL = URL(string: interactor.album.coverImageURL) {downloadCoverTask = imageCover.loadImage(url: coverURL)}
        updateUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {self.scrollView.resizeContentSize()}
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SearchViewController {
            downloadCoverTask?.cancel()
            interactor.cancelLoadArtistTask()
        } else /* Artist view */ {
            let artistView = segue.destination as! ArtistViewController
            artistView.artistProfile = interactor.artistProfile
        }
    }
    
    // MARK: Boundary Methods
    func receiveDataFromOtherViewController(data: Music.Album) {
        interactor.setAlbum(data)
    }
    
    // MARK: Private Methods
    private func updateUI() {
        titleLabel.text = interactor.album.title
        artist.setTitle(interactor.album.artists.first?.name, for: UIControlState())
        yearGenre.text = "\(interactor.album.year) \(interactor.album.genre)"
        let songsText = String(format: NSLocalizedString("%ld Songs", comment: "Number of songs"), interactor.album.tracklist.count)
        footerTrackTotal.text = "\(songsText), \(totalDuration())"
        footerLabel.text = "℗ " + interactor.album.label
        tableView.reloadData()
    }
    private func totalDuration() -> String {
        guard let list = interactor.album.tracklist else {print("Calculation Failure: No Track List!") ; return String.unknownText }
        var duration: TimeInterval = 0
        for track in list {
            duration += track.duration.parseDuration()
        }
        return duration.stringFrom(interval: duration)
    }
    private func loadArtistDataHandler(_ data: Data) {
        interactor.processArtistData(data: data)
        DispatchQueue.main.async {self.performSegue(withIdentifier: "ArtistSegue", sender: self)}
    }
    private func loadArtistErrorHandler() {
        stopActivityIndicator()
        showNetworkError()
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension AlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.album?.tracklist.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        
        guard let hasTrackList = interactor.album?.tracklist else {return cell}
        let row = indexPath.row
        let track = hasTrackList[row]
        cell.configure(with: track, row: row + 1)
        return cell
    }
}
