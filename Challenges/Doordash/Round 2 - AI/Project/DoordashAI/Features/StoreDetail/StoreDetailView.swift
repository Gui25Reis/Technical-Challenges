//
//  StoreDetailView.swift
//  DoordashAI
//

import UIKit

/// Contrato que o Controller usa pra comandar a View (loading/erro/dados do menu).
protocol StoreDetailViewDisplaying: AnyObject {
    func reloadMenu()
    func showMenuLoading()
    func showMenuError(_ message: String)
}

final class StoreDetailView: UIView {

    private let tableHandler = StoreDetailTableViewHandler()

    private let headerView = StoreDetailHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 220))

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.reuseIdentifier)
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        backgroundColor = .systemBackground
        tableView.dataSource = tableHandler
        tableView.tableHeaderView = headerView

        addSubview(tableView)
        addSubview(activityIndicator)
        addSubview(errorLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24)
        ])
    }

    func configure(with store: Store) {
        headerView.configure(with: store)
    }

    /// Chamado pelo Controller antes de reloadMenu()/showMenuError().
    func update(menuItems: [MenuItem]) {
        tableHandler.update(menuItems: menuItems)
    }
}

extension StoreDetailView: StoreDetailViewDisplaying {
    func reloadMenu() {
        errorLabel.isHidden = true
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }

    func showMenuLoading() {
        errorLabel.isHidden = true
        tableView.isHidden = true
        activityIndicator.startAnimating()
    }

    func showMenuError(_ message: String) {
        activityIndicator.stopAnimating()
        tableView.isHidden = true
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

