//
//  OrderHistoryViewController.swift
//
//  Copyright © 2024 DoorDash. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController {
    let viewModel = OrderHistoryViewModel()
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    
    private let reuseID = "OrderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Orders"
        
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        
        viewModel.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor),
        ])
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.onAppear()
    }
}

extension OrderHistoryViewController: OrderHistoryViewModelDelegate {
    func didUpdateOrders(orders: [Order]) {
        tableView.reloadData()
        if !orders.isEmpty {
            activityIndicator.stopAnimating()
        }
    }
}

extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        let order = viewModel.orders[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = order.storeName
        config.secondaryText = order.description
        cell.contentConfiguration = config
        
        return cell
    }
}
