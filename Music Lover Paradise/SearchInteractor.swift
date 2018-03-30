//
//  SearchInteractor.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 30/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// ATTENTION : This is the domain object for SearchViewTrait, it is like a manager for all data manipulations, normally it will ask database or apiWorker for data and report the result to its viewController. And we can unite test this class if we want.
protocol SearchInteractorDelegate {
    var searchResults: [Music.Result] {get}
    var album: Music.Album? {get}
    func search(with text: String, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void)
    func processSearchData(data: Data)
    func loadAlbum(at indexPath: IndexPath, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void)
    func processAlbumData(data: Data)
}
class SearchInteractor: SearchInteractorDelegate {
    private let api: APIWorkerDelegate = DiscogsAPIWorker()
    private(set) var searchResults = [Music.Result]()
    private var selectedResult: Music.Result!
    private(set) var album: Music.Album?
    private var searchTask: URLSessionDataTask?
    private var loadAlbumTask: URLSessionDataTask?
    
    func search(with text: String, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void) {
        searchTask?.cancel()
        let url = URL.discogs(searchText: text)
        searchTask = api.urlSessionDataTask(url: url, prehandler: prehandler, dataHandler: dataHandler, errorHandler: errorHandler)
    }
    func processSearchData(data: Data) {
        searchResults = data.parseTo(jsonType: JSON.ResultArray.self)?.results.map{$0.toMusic()} ?? []
        searchResults.sort(by: newestFirst)
    }
    func loadAlbum(at indexPath: IndexPath, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void) {
        searchTask?.cancel()
        loadAlbumTask?.cancel()
        selectedResult = searchResults[indexPath.row]
        let urlString = selectedResult.resource_url
        let url = URL.discogs(resourceURL: urlString)
        loadAlbumTask = api.urlSessionDataTask(url: url, prehandler: prehandler, dataHandler: dataHandler, errorHandler: errorHandler)
    }
    func processAlbumData(data: Data) {
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
