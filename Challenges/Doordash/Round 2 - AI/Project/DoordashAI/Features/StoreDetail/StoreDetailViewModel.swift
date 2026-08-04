//
//  StoreDetailViewModel.swift
//  DoordashAI
//

import Foundation

protocol StoreDetailViewModelProtocol: AnyObject {
    var delegate: StoreDetailViewModelDelegate? { get set }
    var store: Store { get }
    var menuItems: [MenuItem] { get }
    func loadMenu()
}

protocol StoreDetailViewModelDelegate: AnyObject {
    func viewModelDidUpdateMenu(_ viewModel: StoreDetailViewModelProtocol)
    func viewModel(_ viewModel: StoreDetailViewModelProtocol, didFailWithError message: String)
}

final class StoreDetailViewModel: StoreDetailViewModelProtocol {

    weak var delegate: StoreDetailViewModelDelegate?

    let store: Store
    private(set) var menuItems: [MenuItem] = []
    private let repository: StoreRepositoryProtocol

    init(store: Store, repository: StoreRepositoryProtocol = StoreRepository()) {
        self.store = store
        self.repository = repository
        self.repository.delegate = self
    }

    func loadMenu() {
        repository.fetchMenu()
    }
}

extension StoreDetailViewModel: StoreRepositoryDelegate {
    func repository(_ repository: StoreRepositoryProtocol, didFetchStores stores: [Store]) {
        // Não utilizado por este ViewModel.
    }

    func repository(_ repository: StoreRepositoryProtocol, didFetchMenu menu: Menu) {
        menuItems = menu.items
        delegate?.viewModelDidUpdateMenu(self)
    }

    func repository(_ repository: StoreRepositoryProtocol, didFailWithError error: Error) {
        delegate?.viewModel(self, didFailWithError: "Não foi possível carregar o menu.")
    }
}
