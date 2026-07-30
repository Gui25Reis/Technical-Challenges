//
//  StoreListViewModel.swift
//  DoordashAI
//

import Foundation

protocol StoreListViewModelProtocol: AnyObject {
    var delegate: StoreListViewModelDelegate? { get set }
    var stores: [Store] { get }
    func loadStores()
    func didSelectStore(at index: Int)
    func search(query: String)
}

protocol StoreListViewModelDelegate: AnyObject {
    func viewModelDidUpdateStores(_ viewModel: StoreListViewModelProtocol)
    func viewModel(_ viewModel: StoreListViewModelProtocol, didFailWithError message: String)
    func viewModel(_ viewModel: StoreListViewModelProtocol, didSelectStore store: Store)
}

final class StoreListViewModel: StoreListViewModelProtocol {

    private static let minimumQueryLength = 2
    private static let debounceNanoseconds: UInt64 = 500_000_000 // 0.5s

    weak var delegate: StoreListViewModelDelegate?

    private(set) var stores: [Store] = []
    private var allStores: [Store] = []
    private let repository: StoreRepositoryProtocol
    private var searchTask: Task<Void, Never>?

    init(repository: StoreRepositoryProtocol = StoreRepository()) {
        self.repository = repository
        self.repository.delegate = self
    }

    func loadStores() {
        repository.fetchStores()
    }

    func didSelectStore(at index: Int) {
        delegate?.viewModel(self, didSelectStore: stores[index])
    }

    func search(query: String) {
        searchTask?.cancel()

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedQuery.count >= Self.minimumQueryLength else {
            stores = allStores
            delegate?.viewModelDidUpdateStores(self)
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: Self.debounceNanoseconds)
            guard let self, !Task.isCancelled else { return }
            self.stores = self.allStores.filter { $0.name.localizedCaseInsensitiveContains(trimmedQuery) }
            self.delegate?.viewModelDidUpdateStores(self)
        }
    }
}

extension StoreListViewModel: StoreRepositoryDelegate {
    func repository(_ repository: StoreRepositoryProtocol, didFetchStores stores: [Store]) {
        allStores = stores
        self.stores = stores
        delegate?.viewModelDidUpdateStores(self)
    }

    func repository(_ repository: StoreRepositoryProtocol, didFetchMenu menu: Menu) {
        // Não utilizado por este ViewModel.
    }

    func repository(_ repository: StoreRepositoryProtocol, didFailWithError error: Error) {
        delegate?.viewModel(self, didFailWithError: "Não foi possível carregar as lojas.")
    }
}
