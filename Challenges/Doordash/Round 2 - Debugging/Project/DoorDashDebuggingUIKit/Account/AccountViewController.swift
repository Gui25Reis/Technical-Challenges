//
//  AccountViewController.swift
//  DoorDashDebuggingUIKit
//
//  Created by shawn wu on 4/12/24.
//

import UIKit

final class AccountViewController: UIViewController {
    private let coordinator = Coordinator()
    
    enum Section: Int, CaseIterable {
        case navigation = 0
        case notifications = 1
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let cellModels: [AccountCellModel] = [
        .init(title: "Payments", image: "creditcard", navigationDestination: .payments),
        .init(title: "Legal", image: "folder", navigationDestination: .legal),
        .init(title: "DashPass", image: "list.bullet.rectangle", navigationDestination: .dashpass),
        .init(title: "Dark Mode", image: "rectangle.and.paperclip", navigationDestination: .darkmode)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setUpTableView()
        
        setUpCartPill()
        
        title = "Account"
        
        coordinator.navigationController = navigationController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(AccountCellView.self, forCellReuseIdentifier: AccountCellView.id)
        tableView.register(AccountNotificationCellView.self, forCellReuseIdentifier: AccountNotificationCellView.id)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpCartPill() {
        let pill = OrderCartPill()
        view.addSubview(pill)
        pill.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pill.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pill.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pill.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pill.heightAnchor.constraint(equalToConstant: 50),
        ])
        pill.updateView(middleTitle: "VIEW CART")
        pill.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cartPillTapped)))
    }
    
    @objc private func cartPillTapped() {
        coordinator.navigate(to: .ordercart)
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .navigation:
            guard (0..<cellModels.count).contains(indexPath.item) else {
                return UITableViewCell()
            }
            
            guard let cellView = tableView.dequeueReusableCell(
                withIdentifier: AccountCellView.id,
                for: indexPath
            ) as? AccountCellView else {
                return UITableViewCell()
            }
            
            cellView.model = cellModels[indexPath.item]
            
            return cellView
        case .notifications:
            guard let cellView = tableView.dequeueReusableCell(
                withIdentifier: AccountNotificationCellView.id,
                for: indexPath
            ) as? AccountNotificationCellView else {
                return UITableViewCell()
            }
            
            return cellView
        case .none:
            assertionFailure("Invalid section")
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .navigation:
            return cellModels.count
        case .notifications:
            return 1
        case .none:
            assertionFailure("Invalid section")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .navigation:
            let cellModel = cellModels[indexPath.item]
            coordinator.navigate(to: cellModel.navigationDestination)
        case .notifications, .none:
            break
        }
    }
}

