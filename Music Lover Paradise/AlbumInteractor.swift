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
}

class AlbumInteractor: AlbumInteractorDelegate {
    private let api: APIWorkerDelegate = DiscogsAPIWorker()
    private(set) var album: Music.Album?
    
}
