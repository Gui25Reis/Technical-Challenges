//
//  MenuItemCell.swift
//  DoordashAI
//

import UIKit

final class MenuItemCell: UITableViewCell {

    static let reuseIdentifier = "MenuItemCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: MenuItem) {
        var content = defaultContentConfiguration()
        content.text = item.name
        content.secondaryText = CurrencyFormatter.string(fromCents: item.priceCents)
        contentConfiguration = content
    }
}
