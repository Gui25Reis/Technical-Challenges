//
//  StoreDetailViewController.swift
//  DoordashAI
//

import UIKit

final class StoreDetailViewController: UIViewController {

    private let detailView = StoreDetailView()
    private let viewModel: StoreDetailViewModelProtocol

    init(store: Store) {
        self.viewModel = StoreDetailViewModel(store: store)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        title = viewModel.store.name
        detailView.configure(with: viewModel.store)

        detailView.showMenuLoading()
        viewModel.loadMenu()
    }
}

extension StoreDetailViewController: StoreDetailViewModelDelegate {
    func viewModelDidUpdateMenu(_ viewModel: StoreDetailViewModelProtocol) {
        detailView.update(menuItems: viewModel.menuItems)
        detailView.reloadMenu()
    }

    func viewModel(_ viewModel: StoreDetailViewModelProtocol, didFailWithError message: String) {
        detailView.showMenuError(message)
    }
}
