//
//  ViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

// ATTENTION : Now our viewController become merely a coordinator between the interactor and it's subviews, massiveViewController's problem resolved.
class SearchViewController: UITableViewController, SearchViewTrait {
    let interactor: SearchInteractorDelegate = SearchInteractor()
    var hasSearched = false
    var isLoading = false
    var activityView: UIVisualEffectView?
    var selectedIndexPath: IndexPath?
    let searchResultCell = "SearchResultCell"
    let nothingFoundCell = "NothingFoundCell"
    let loadingCell = "LoadingCell"
    
    // MARK: - View LifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchViewDidAppear()
    }
    
    // MARK: - UITableView DataSource & Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewNumberOfRows()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return searchViewCellForRow(at: indexPath)
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return searchViewWillSelectRowAt(indexPath: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchViewDidSelectRow(at: indexPath)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchViewPrepare(for: segue, sender: sender)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewSearchButtonClicked(searchBar)
    }
    
    // MARK: - UISearchControllerDelegate
    func didPresentSearchController(_ searchController: UISearchController) {
        searchViewDidPresentSearchController(searchController)
    }
}

