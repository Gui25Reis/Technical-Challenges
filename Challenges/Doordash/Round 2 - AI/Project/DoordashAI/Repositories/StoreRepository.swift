//
//  StoreRepository.swift
//  DoordashAI
//

import Foundation

protocol StoreRepositoryProtocol: AnyObject {
    var delegate: StoreRepositoryDelegate? { get set }
    func fetchStores()
    func fetchMenu()
}

protocol StoreRepositoryDelegate: AnyObject {
    func repository(_ repository: StoreRepositoryProtocol, didFetchStores stores: [Store])
    func repository(_ repository: StoreRepositoryProtocol, didFetchMenu menu: Menu)
    func repository(_ repository: StoreRepositoryProtocol, didFailWithError error: Error)
}

/// Único ponto do app que conhece `async/await`: por fora, tudo se comunica via delegate.
final class StoreRepository: StoreRepositoryProtocol {

    weak var delegate: StoreRepositoryDelegate?

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchStores() {
        Task {
            do {
                let stores: [Store] = try await apiClient.fetch(.storeFeed)
                await MainActor.run { delegate?.repository(self, didFetchStores: stores) }
            } catch {
                await MainActor.run { delegate?.repository(self, didFailWithError: error) }
            }
        }
    }

    func fetchMenu() {
        Task {
            do {
                let menu: Menu = try await apiClient.fetch(.menu)
                await MainActor.run { delegate?.repository(self, didFetchMenu: menu) }
            } catch {
                await MainActor.run { delegate?.repository(self, didFailWithError: error) }
            }
        }
    }
}
