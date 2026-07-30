//
//  StoreListTableViewHandler.swift
//  DoordashAI
//

import UIKit

protocol StoreListTableViewHandlerDelegate: AnyObject {
    func tableViewHandler(_ handler: StoreListTableViewHandler, didSelectStoreAt index: Int)
}

/// Concentra UITableViewDataSource/UITableViewDelegate da lista de lojas,
/// mantendo a StoreListView focada só em layout e estados (loading/erro).
final class StoreListTableViewHandler: NSObject {

    weak var delegate: StoreListTableViewHandlerDelegate?

    private var stores: [Store] = []

    func update(stores: [Store]) {
        self.stores = stores
    }
}

extension StoreListTableViewHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreCell.reuseIdentifier, for: indexPath) as? StoreCell else {
            return UITableViewCell()
        }
        cell.configure(with: stores[indexPath.row])
        return cell
    }
}

extension StoreListTableViewHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.tableViewHandler(self, didSelectStoreAt: indexPath.row)
    }
}
