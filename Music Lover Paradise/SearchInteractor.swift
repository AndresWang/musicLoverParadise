//
//  SearchInteractor.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 30/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

protocol SearchInteractorDelegate {
    var searchResults: [Music.Result] {get}
    var album: Music.Album? {get}
    
    func search(with text: String, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void) -> URLSessionDataTask
    func processSearchData(data: Data)
    func loadAlbum(at indexPath: IndexPath, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void) -> URLSessionDataTask
    func processAlbumData(at indexPath: IndexPath, data: Data)
}

class SearchInteractor: SearchInteractorDelegate {
    private let api: APIWorkerDelegate = DiscogsAPIWorker()
    private(set) var searchResults = [Music.Result]()
    private(set) var album: Music.Album?
    
    func search(with text: String, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void) -> URLSessionDataTask {
        let url = URL.discogs(searchText: text)
        let dataTask = api.urlSessionDataTask(url: url, prehandler: prehandler, dataHandler: dataHandler, errorHandler: errorHandler)
        return dataTask
    }
    func processSearchData(data: Data) {
        searchResults = data.parseTo(jsonType: JSON.ResultArray.self)?.results.map{$0.toMusic()} ?? []
        searchResults.sort(by: newestFirst)
    }
    func loadAlbum(at indexPath: IndexPath, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void) -> URLSessionDataTask {
        let urlString = searchResults[indexPath.row].resource_url
        let url = URL.discogs(resourceURL: urlString)
        let loadAlbumTask = api.urlSessionDataTask(url: url, prehandler: prehandler, dataHandler: dataHandler, errorHandler: errorHandler)
        return loadAlbumTask
    }
    func processAlbumData(at indexPath: IndexPath, data: Data) {
        let selectedResult = searchResults[indexPath.row]
        let coverImageURL = selectedResult.cover_image
        let year = selectedResult.year ?? String.unknownText
        let genre = selectedResult.genre.first ?? String.unknownText
        let label = selectedResult.label.joined(separator: ", ")
        album = data.parseTo(jsonType: JSON.Album.self).map{$0.toMusic(coverImageURL: coverImageURL, year: year, genre: genre, label: label)}
    }
    
    // MARK: Private Methods
    private func newestFirst (lhs: Music.Result, rhs: Music.Result) -> Bool {
        let lhsYear = Int(lhs.year ?? "0") ?? 0
        let rhsYear = Int(rhs.year ?? "0") ?? 0
        return lhsYear > rhsYear
    }
}
