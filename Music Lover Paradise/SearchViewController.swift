//
//  ViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    var searchResults = [Result]()
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?
    var selectedIndexPath: IndexPath?
    
    struct CellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView Setups
        tableView.rowHeight = 80
        
        // Add SearchBar
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.definesPresentationContext = true
        search.searchBar.delegate = self
        search.searchBar.placeholder = NSLocalizedString("Album Title", comment: "A placeholder to search album" )
        search.searchBar.tintColor = #colorLiteral(red: 0.9071379304, green: 0.2433879375, blue: 0.2114798129, alpha: 1)
        navigationItem.searchController = search
        
        // Register Nibs
        let nothingFoundCellNib = UINib(nibName: CellIdentifiers.nothingFoundCell, bundle: nil)
        let loadingCellNib = UINib(nibName: CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(nothingFoundCellNib, forCellReuseIdentifier: CellIdentifiers.nothingFoundCell)
        tableView.register(loadingCellNib, forCellReuseIdentifier: CellIdentifiers.loadingCell)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if searchResults.isEmpty {navigationItem.searchController?.isActive = true}
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = selectedIndexPath, let albumView = segue.destination as? AlbumViewController, segue.identifier == "AlbumSegue" else {return}
        let selectedResult = searchResults[indexPath.row]
        albumView.coverImageURL = selectedResult.cover_image
        albumView.albumYear = selectedResult.year ?? String.unknownText()
        albumView.albumGenre = selectedResult.genre.first ?? String.unknownText()
        albumView.albumLabel = selectedResult.label.joined(separator: ", ")
    }
}

// MARK:- UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {print("No String Entered");searchBar.resignFirstResponder();return}
        
        // Cancel previous task
        dataTask?.cancel()
        
        // Preparation
        searchBar.resignFirstResponder()
        tableView.contentOffset = .zero
        isLoading = true
        tableView.reloadData()
        hasSearched = true
        searchResults = []
        
        // URLSession
        let session = URLSession.shared
        dataTask = session.dataTask(with: URL.discogs(searchText: text)) { data, response, error in
            if let error = error as NSError?, error.code == -999 {
                return // Search was cancelled
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    self.searchResults = data.parseToResults()
                    self.searchResults.sort(by: >)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                        self.navigationItem.searchController?.isActive = false
                    }
                    return // Exit the closure
                }
            } else {
                print("URLSession Failure! \(String(describing: response))")                
            }
            
            // Handle errors
            DispatchQueue.main.async {
                self.hasSearched = false
                self.isLoading = false
                self.tableView.reloadData()
                self.navigationItem.searchController?.isActive = false
                self.showNetworkError()
            }
        }
        dataTask?.resume()
    }
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK:- UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {searchController.searchBar.becomeFirstResponder()}
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.loadingCell, for: indexPath)
            let spinner = loadingCell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return loadingCell
        } else if searchResults.count == 0 {
            let nothingFoundCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.nothingFoundCell, for: indexPath)
            return nothingFoundCell
        } else {
            let searchResultCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            searchResultCell.configure(for: searchResults[indexPath.row])
            return searchResultCell
        }
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 || isLoading {
            selectedIndexPath = nil
            return nil
        } else {
            selectedIndexPath = indexPath
            return indexPath
        }
    }
}

