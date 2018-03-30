//
//  SearchViewTrait.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 30/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

// ATTENTION : This protocol and its extension not noly make our searchViewController extremely light, but also make its code shareable for all UITableViewControllers. This is protocol oriented programming's composition. I prefer composition over inheritance, because it is much more flexible. I used this technique in my own project because I have four UITableViewControllers which need the same essential funtionality, but each view still has its own specialties.
protocol SearchViewTrait: UISearchControllerDelegate, UISearchBarDelegate, ActivityIndicatable {
    var interactor: SearchInteractorDelegate {get}
    var hasSearched: Bool {get set}
    var isLoading: Bool {get set}
    var activityView: UIVisualEffectView? {get set}
    var selectedIndexPath: IndexPath? {get set}
    var searchResultCell: String {get}
    var nothingFoundCell: String {get}
    var loadingCell: String {get}
    func searchViewDidLoad()
    func searchViewDidAppear()
    func searchViewPrepare(for segue: UIStoryboardSegue, sender: Any?)
    func searchViewNumberOfRows() -> Int
    func searchViewCellForRow(at indexPath: IndexPath) -> UITableViewCell
    func searchViewWillSelectRowAt(indexPath: IndexPath) -> IndexPath?
    func searchViewDidSelectRow(at indexPath: IndexPath)
    func searchViewSearchButtonClicked(_ searchBar: UISearchBar)
    func searchViewDidPresentSearchController(_ searchController: UISearchController)
}
extension SearchViewTrait where Self: UITableViewController {
    // MARK: - View Life Cycle & Navigation
    func searchViewDidLoad() {
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
        let nothingFoundCellNib = UINib(nibName: nothingFoundCell, bundle: nil)
        let loadingCellNib = UINib(nibName: loadingCell, bundle: nil)
        tableView.register(nothingFoundCellNib, forCellReuseIdentifier: nothingFoundCell)
        tableView.register(loadingCellNib, forCellReuseIdentifier: loadingCell)
    }
    func searchViewDidAppear() {
        guard interactor.searchResults.isEmpty else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {self.navigationItem.searchController?.isActive = true}
    }
    func searchViewPrepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let albumView = segue.destination as? AlbumViewController, let album = interactor.album, segue.identifier == "AlbumSegue" else {return}
        albumView.receiveDataFromOtherViewController(data: album)
    }
    
    // MARK: - UITableView DataSource & Delegate
    func searchViewNumberOfRows() -> Int {
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
    func searchViewCellForRow(at indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if interactor.searchResults.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nothingFoundCell, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCell, for: indexPath) as! SearchResultCell
            cell.configure(for: interactor.searchResults[indexPath.row])
            return cell
        }
    }
    func searchViewWillSelectRowAt(indexPath: IndexPath) -> IndexPath? {
        if interactor.searchResults.count == 0 || isLoading {
            selectedIndexPath = nil
            return nil
        } else {
            selectedIndexPath = indexPath
            return indexPath
        }
    }
    func searchViewDidSelectRow(at indexPath: IndexPath) {
        guard let indexPath = selectedIndexPath else {return}
        activityView = view.showActivityPanel(message: NSLocalizedString("Loading...", comment: "Network working"))
        interactor.loadAlbum(at: indexPath, prehandler: stopActivityIndicator, dataHandler: loadAlbumDataHandler, errorHandler: loadAlbumErrorHandler)
    }
    
    // MARK: - UISearchBarDelegate
    func searchViewSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {print("No String Entered");searchBar.resignFirstResponder();return}
        searchBar.resignFirstResponder()
        tableView.contentOffset = .zero
        isLoading = true
        tableView.reloadData()
        hasSearched = true
        interactor.search(with: text, prehandler: nil, dataHandler: searchDataHandler, errorHandler: searchErrorHandler)
    }
    
    // MARK: - UISearchControllerDelegate
    func searchViewDidPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {searchController.searchBar.becomeFirstResponder()}
    }
    
    // MARK: - Private Methods
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
    private func loadAlbumDataHandler(data: Data) {
        interactor.processAlbumData(data: data)
        DispatchQueue.main.async {self.performSegue(withIdentifier: "AlbumSegue", sender: self)}
    }
    private func loadAlbumErrorHandler() {
        stopActivityIndicator()
        showNetworkError()
    }
}


