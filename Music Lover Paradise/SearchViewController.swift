//
//  ViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchResults = [Result]()
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView Setups
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 54, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        
        // Register Nibs
        let searchResultCellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        let nothingFoundCellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        let loadingCellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.register(searchResultCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        tableView.register(nothingFoundCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        tableView.register(loadingCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        // Actions
        searchBar.becomeFirstResponder()
    }
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    // MARK: - Private Methods
    private func showNetworkError() {
        let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "Network error title"), message: NSLocalizedString("There was an error accessing Discogs database. Please try again", comment: "Network error message"), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {print("No String Entered");searchBar.resignFirstResponder();return}
        
        // Cancel previous task
        dataTask?.cancel()
        
        // Preparation
        tableView.contentOffset = .zero
        searchBar.resignFirstResponder()
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
                    }
                    return // Exit the closure
                }
            } else {
                print("Failure! \(response!)")
            }
            
            // Handle errors
            DispatchQueue.main.async {
                self.hasSearched = false
                self.isLoading = false
                self.tableView.reloadData()
                self.showNetworkError()
            }
        }
        dataTask?.resume()
    }
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell, for: indexPath)
            let spinner = loadingCell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return loadingCell
        } else if searchResults.count == 0 {
            let nothingFoundCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
            return nothingFoundCell
        } else {
            let searchResultCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            searchResultCell.configure(for: searchResults[indexPath.row])
            return searchResultCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}

