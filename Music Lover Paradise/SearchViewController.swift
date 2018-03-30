//
//  ViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, ActivityIndicatable {
    let interactor: SearchInteractorDelegate = SearchInteractor()
    var searchTask: URLSessionDataTask?
    var hasSearched = false
    var isLoading = false
    var loadAlbumTask: URLSessionDataTask?
    var activityView: UIVisualEffectView?
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
        title = NSLocalizedString("Search", comment: "Big nav title")
        
        // Add SearchBar
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.definesPresentationContext = true
        search.searchBar.delegate = self
        search.searchBar.placeholder = NSLocalizedString("Album Title", comment: "A placeholder to search album" )
        search.searchBar.tintColor = #colorLiteral(red: 0.9071379304, green: 0.2433879375, blue: 0.2114798129, alpha: 1)
        navigationItem.searchController = search
        search.searchBar.accessibilityIdentifier = "mySearchBar"
        
        // Register Nibs
        let nothingFoundCellNib = UINib(nibName: CellIdentifiers.nothingFoundCell, bundle: nil)
        let loadingCellNib = UINib(nibName: CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(nothingFoundCellNib, forCellReuseIdentifier: CellIdentifiers.nothingFoundCell)
        tableView.register(loadingCellNib, forCellReuseIdentifier: CellIdentifiers.loadingCell)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard interactor.searchResults.isEmpty else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {self.navigationItem.searchController?.isActive = true}
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let albumView = segue.destination as? AlbumViewController, segue.identifier == "AlbumSegue" else {return}
        albumView.album = interactor.album
    }
}

// MARK:- UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {print("No String Entered");searchBar.resignFirstResponder();return}
        
        // Cancel previous task
        searchTask?.cancel()
        
        // Start search task
        searchBar.resignFirstResponder()
        tableView.contentOffset = .zero
        isLoading = true
        tableView.reloadData()
        hasSearched = true
        searchTask = interactor.search(with: text, prehandler: nil, dataHandler: searchDataHandler, errorHandler: searchErrorHandler)
    }
    
    // Private Methods
    private func searchDataHandler(data: Data) {
        interactor.processSearchData(data: data)
        DispatchQueue.main.async {
            self.isLoading = false
            self.tableView.reloadData()
            self.navigationItem.searchController?.isActive = false
        }
    }
    private func searchErrorHandler() {
        hasSearched = false
        isLoading = false
        tableView.reloadData()
        navigationItem.searchController?.isActive = false
        showNetworkError()
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
        } else if interactor.searchResults.count == 0 {
            return 1
        } else {
            return interactor.searchResults.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.loadingCell, for: indexPath)
            let spinner = loadingCell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return loadingCell
        } else if interactor.searchResults.count == 0 {
            let nothingFoundCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.nothingFoundCell, for: indexPath)
            return nothingFoundCell
        } else {
            let searchResultCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            searchResultCell.configure(for: interactor.searchResults[indexPath.row])
            return searchResultCell
        }
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if interactor.searchResults.count == 0 || isLoading {
            selectedIndexPath = nil
            return nil
        } else {
            selectedIndexPath = indexPath
            return indexPath
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = selectedIndexPath else {return}
        activityView = view.showActivityPanel(message: NSLocalizedString("Loading...", comment: "Network working"))
        searchTask?.cancel()
        loadAlbumTask?.cancel()
        loadAlbumTask = interactor.loadAlbum(at: indexPath, prehandler: stopActivityIndicator, dataHandler: loadAlbumDataHandler, errorHandler: loadAlbumErrorHandler)
    }
    
    // Private Methods
    private func loadAlbumDataHandler(data: Data) {
        guard let indexPath = selectedIndexPath else {return}
        interactor.processAlbumData(at: indexPath, data: data)
        DispatchQueue.main.async {self.performSegue(withIdentifier: "AlbumSegue", sender: self)}
    }
    private func loadAlbumErrorHandler() {
        stopActivityIndicator()
        showNetworkError()
    }
}

