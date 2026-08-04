//
//  OrderCartViewController.swift
//  DoorDashDebuggingUIKit
//
//  Created by shawn wu on 4/12/24.
//

import UIKit

final class OrderCartViewController: UIViewController {
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var pill = OrderCartPill()
    
    private let viewModel = OrderCartViewModel()
    
    private var cartItems: [OrderCartResponse.CartItem] = []
    
    private var error: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Cart"
        view.backgroundColor = .white
        
        setUpTableView()
        setUpCartPill()
        
        viewModel.delegate = self
        viewModel.fetchCartDetails()
    }
    
    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.rowHeight = 80
        tableView.register(OrderCartItemCell.self, forCellReuseIdentifier: OrderCartItemCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpCartPill() {
        pill.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pill)
        
        NSLayoutConstraint.activate([
            pill.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pill.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pill.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pill.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

extension OrderCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCartItemCell.reuseIdentifier, for: indexPath) as? OrderCartItemCell
        cell?.model = cartItems[indexPath.row]
        cell?.delegate = self
        return cell ?? .init()
    }
}

extension OrderCartViewController: OrderCartViewModelDelegate {
    func didUpdateCart(items: [OrderCartResponse.CartItem]?, total: String?, error: (any Error)?) {
        cartItems = items ?? []
        tableView.reloadData()
        pill.updateView(leadingTitle: "Checkout", trailingTitle: total)
    }
}

extension OrderCartViewController: OrderCartItemCellDelegate {
    func didUpdateQuantity(for item: OrderCartResponse.CartItem, quantity: Int) {
        viewModel.update(quantity: quantity, itemId: item.id)
    }
}
