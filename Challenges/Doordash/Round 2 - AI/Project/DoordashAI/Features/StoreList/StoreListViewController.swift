//
//  StoreListViewController.swift
//  DoordashAI
//

import UIKit

final class StoreListViewController: UIViewController {

    private let storeListView = StoreListView()
    private let viewModel: StoreListViewModelProtocol
    private let searchController = UISearchController(searchResultsController: nil)

    init(viewModel: StoreListViewModelProtocol = StoreListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = storeListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stores"
        storeListView.delegate = self
        viewModel.delegate = self
        setUpSearch()

        storeListView.showLoading()
        viewModel.loadStores()
    }

    private func setUpSearch() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search stores"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension StoreListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.search(query: searchController.searchBar.text ?? "")
    }
}

extension StoreListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        storeListView.setFeaturedHeaderHidden(true)
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        storeListView.setFeaturedHeaderHidden(false)
        viewModel.search(query: "")
    }
}

extension StoreListViewController: StoreListViewDelegate {
    func storeListView(_ view: StoreListView, didSelectRowAt index: Int) {
        viewModel.didSelectStore(at: index)
    }
}

extension StoreListViewController: StoreListViewModelDelegate {
    func viewModelDidUpdateStores(_ viewModel: StoreListViewModelProtocol) {
        storeListView.update(stores: viewModel.stores)
        storeListView.reloadData()
    }

    func viewModel(_ viewModel: StoreListViewModelProtocol, didFailWithError message: String) {
        storeListView.showError(message)
    }

    func viewModel(_ viewModel: StoreListViewModelProtocol, didSelectStore store: Store) {
        navigationController?.pushViewController(StoreDetailViewController(store: store), animated: true)
    }
}
