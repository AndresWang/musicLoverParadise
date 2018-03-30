//
//  AlbumInteractor.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 30/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

protocol AlbumInteractorDelegate {
    var album: Music.Album! {get}
    var artistProfile: Music.ArtistProfile? {get}
    func setAlbum(_ album: Music.Album)
    func loadArtist(with url: String, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void)
    func processArtistData(data: Data)
    func cancelLoadArtistTask()
}

class AlbumInteractor: AlbumInteractorDelegate {
    private let api: APIWorkerDelegate = DiscogsAPIWorker()
    private(set) var album: Music.Album!
    private(set) var artistProfile: Music.ArtistProfile?
    private var loadArtistTask: URLSessionDataTask?
    
    func setAlbum(_ album: Music.Album) {
        self.album = album
    }
    func loadArtist(with url: String, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void) {
        loadArtistTask?.cancel()
        loadArtistTask = api.urlSessionDataTask(url: URL.discogs(resourceURL: url), prehandler: prehandler, dataHandler: dataHandler, errorHandler: errorHandler)
    }
    func processArtistData(data: Data) {
        artistProfile = data.parseTo(jsonType: JSON.ArtistProfile.self).map{$0.toMusic()}
    }
    func cancelLoadArtistTask() {
        loadArtistTask?.cancel()
    }
    
}
