//
//  AlbumInteractor.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 30/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

protocol AlbumInteractorDelegate {
    var album: Music.Album? {get}
    func setAlbum(_ album: Music.Album?)
}

class AlbumInteractor: AlbumInteractorDelegate {
    private let api: APIWorkerDelegate = DiscogsAPIWorker()
    private(set) var album: Music.Album?
    private var downloadCoverTask: URLSessionDownloadTask?
    private var loadArtistTask: URLSessionDataTask?
    private var artistProfile: ArtistProfile?
    
    func setAlbum(_ album: Music.Album?) {
        self.album = album
    }
}
