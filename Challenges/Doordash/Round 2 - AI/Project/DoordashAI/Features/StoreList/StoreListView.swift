//
//  StoreListView.swift
//  DoordashAI
//

import UIKit

protocol StoreListViewDelegate: AnyObject {
    func storeListView(_ view: StoreListView, didSelectRowAt index: Int)
}

/// Contrato que o Controller usa pra comandar a View (loading/erro/dados).
protocol StoreListViewDisplaying: AnyObject {
    func reloadData()
    func showLoading()
    func showError(_ message: String)
    func setFeaturedHeaderHidden(_ hidden: Bool)
}

final class StoreListView: UIView {

    weak var delegate: StoreListViewDelegate?

    private let tableHandler = StoreListTableViewHandler()
    private let featuredHeaderView = StoreListFeaturedHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 120))
    private var isFeaturedHeaderHidden = false

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StoreCell.self, forCellReuseIdentifier: StoreCell.reuseIdentifier)
        tableView.rowHeight = 96
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
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
        tableHandler.delegate = self
        featuredHeaderView.delegate = self
        tableView.dataSource = tableHandler
        tableView.delegate = tableHandler
        tableView.tableHeaderView = featuredHeaderView

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

    /// Chamado pelo Controller antes de reloadData()/showError().
    /// Fora de busca: as 3 primeiras lojas vão pro header, o restante pra lista.
    /// Durante a busca (header escondido): a lista mostra todos os resultados, sem reservar nada pro header.
    func update(stores: [Store]) {
        if isFeaturedHeaderHidden {
            tableHandler.update(stores: stores)
        } else {
            featuredHeaderView.configure(with: Array(stores.prefix(3)))
            tableHandler.update(stores: Array(stores.dropFirst(3)))
        }
    }
}

extension StoreListView: StoreListViewDisplaying {
    func reloadData() {
        errorLabel.isHidden = true
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }

    func showLoading() {
        errorLabel.isHidden = true
        tableView.isHidden = true
        activityIndicator.startAnimating()
    }

    func showError(_ message: String) {
        activityIndicator.stopAnimating()
        tableView.isHidden = true
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    func setFeaturedHeaderHidden(_ hidden: Bool) {
        isFeaturedHeaderHidden = hidden
        tableView.tableHeaderView = hidden ? nil : featuredHeaderView
    }
}

extension StoreListView: StoreListTableViewHandlerDelegate {
    func tableViewHandler(_ handler: StoreListTableViewHandler, didSelectStoreAt index: Int) {
        // Fora de busca a lista mostra stores[3...] (índice real = index + 3);
        // durante a busca a lista mostra o array inteiro (sem offset).
        let offset = isFeaturedHeaderHidden ? 0 : 3
        delegate?.storeListView(self, didSelectRowAt: index + offset)
    }
}

extension StoreListView: StoreListFeaturedHeaderViewDelegate {
    func featuredHeaderView(_ view: StoreListFeaturedHeaderView, didSelectStoreAt index: Int) {
        delegate?.storeListView(self, didSelectRowAt: index)
    }
}
