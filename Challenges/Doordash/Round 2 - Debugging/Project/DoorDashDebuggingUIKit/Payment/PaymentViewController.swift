//
//  PaymentViewController.swift
//  DoorDashDebuggingUIKit
//
//  Created by shawn wu on 4/12/24.
//

import UIKit

final class PaymentViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var viewModel: PaymentViewModel = {
        let vm = PaymentViewModel()
        vm.delegate = self
        return vm
    }()
    
    private var selectedPayment: PaymentMethod? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpTableView()
        viewModel.getPaymentMethods()
    }
    
    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PaymentMethodTableViewCell.self, forCellReuseIdentifier: PaymentMethodTableViewCell.id)
    }
}

extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellView = tableView.dequeueReusableCell(
            withIdentifier: PaymentMethodTableViewCell.id,
            for: indexPath
        ) as? PaymentMethodTableViewCell else {
            return UITableViewCell()
        }
        
        let paymentMethod = viewModel.paymentMethods[indexPath.row]
        
        let isSelected = selectedPayment?.id == paymentMethod.id
        cellView.configure(with: paymentMethod, isSelected: isSelected)
        
        return cellView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPayment = viewModel.paymentMethods[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteCard(viewModel.paymentMethods[indexPath.row]) { [weak self] in
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

extension PaymentViewController: PaymentViewModel.Delegate {
    func didFetch() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
