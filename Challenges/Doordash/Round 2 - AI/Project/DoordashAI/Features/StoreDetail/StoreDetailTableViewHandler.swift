//
//  StoreDetailTableViewHandler.swift
//  DoordashAI
//

import UIKit

/// Concentra UITableViewDataSource da lista de itens do menu,
/// mantendo a StoreDetailView focada só em layout e estados (loading/erro).
final class StoreDetailTableViewHandler: NSObject {

    private var menuItems: [MenuItem] = []

    func update(menuItems: [MenuItem]) {
        self.menuItems = menuItems
    }
}

extension StoreDetailTableViewHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as? MenuItemCell else {
            return UITableViewCell()
        }
        cell.configure(with: menuItems[indexPath.row])
        return cell
    }
}
