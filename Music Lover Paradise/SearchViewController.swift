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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView Setups
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 54, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        
        // Register Nibs
        let searchResultCellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        let nothingFoundCellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(searchResultCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        tableView.register(nothingFoundCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        // Actions
        searchBar.becomeFirstResponder()
    }
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "Network error title"), message: NSLocalizedString("There was an error accessing Discogs database. Please try again", comment: "Network error message"), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            print("No String Entered")
            searchBar.resignFirstResponder()
            return
        }
        searchBar.resignFirstResponder()
        hasSearched = true
        searchResults = []
        if let data = URL.discogs(searchText: text).requestData() {
            searchResults = data.parseToResults()
            searchResults.sort(by: <)
        } else {
            showNetworkError()
        }
        tableView.reloadData()
    }
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0 {
            return hasSearched ? 1 : 0
        } else {
            return searchResults.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.titleLabel.text = searchResult.title
            cell.artistNameLabel.text = searchResult.artistName
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}

