//
//  ViewController.swift
//  Copyright © 2026 DoorDash, Inc. All rights reserved.
//
// ## Confidentiality Notice
// This interview exercise and all associated materials are confidential
// and proprietary to DoorDash, Inc. By accessing these materials, you
// agree not to share, publish, or distribute any part of this exercise
// or your solution.
//
// Violation of this agreement may result in disqualification from
// consideration for employment at DoorDash.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - UI
    lazy var table: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CustomCell.self, forCellReuseIdentifier: CustomCell.id)
        view.rowHeight = 50
        return view
    }()
    
    private lazy var button = {
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = 8
        configuration.baseForegroundColor = UIColor.black
        configuration.title = "Submit"

        let button = UIButton(
            configuration: configuration,
            primaryAction: UIAction { _ in
                self.sendOrder()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Others
    
    lazy var handler: TableHandlerContract = TableHandler(linkAt: table)
    lazy var service: CheckoutService = {
        let service = CheckoutService()
        service.delegate = self
        return service
    }()
    
    var orderId: String?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsAtScreen()
        service.fetchOrder()
    }
    
    private func addViewsAtScreen() {
        view.addSubview(table)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            button.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            table.leftAnchor.constraint(equalTo: view.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func sendOrder() {
        guard let orderId else { return }
        service.submitOrder(orderId: orderId)
        button.setTitle("Submitting...", for: .normal)
    }
}


extension ViewController: CheckoutServiceDelegate {
    func didSusscefully(with orderId: String) {
        button.setTitle("Submit", for: .normal)
        present(NewVC(), animated: true)
    }
    
    func didSusscefully(with data: CheckoutModels.CheckoutModel) {
        DispatchQueue.main.async {
            self.handler.updateTableData(with: data.items)
            self.table.reloadData()
        }
    }
    
    func didFailure() {
        
    }
}


protocol TableHandlerContract {
    init(linkAt table: UITableView)
    
    func updateTableData(with newData: TableHandler.TableData)
}

class TableHandler: NSObject, UITableViewDelegate, UITableViewDataSource {
    typealias TableData = [CheckoutModels.CheckoutItemModel]
    var allData = TableData()
    
    required init(linkAt table: UITableView) {
        super.init()
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as? CustomCell
        
        let data = allData[indexPath.row]
        cell?.setupCell(with: data)
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension TableHandler: TableHandlerContract {
    func updateTableData(with newData: TableData) {
        allData = newData
    }
}



class NewVC: UIViewController {
    
}
