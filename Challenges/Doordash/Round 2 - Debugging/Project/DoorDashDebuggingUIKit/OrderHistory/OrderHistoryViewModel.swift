//
//  OrdersViewModel.swift
//
//  Copyright © 2024 DoorDash. All rights reserved.
//

import Combine
import Foundation

protocol OrderHistoryViewModelDelegate: AnyObject {
    func didUpdateOrders(orders: [Order])
}

class OrderHistoryViewModel {
    private let service = OrderHistoryService()
    private(set) var orders: [Order] = []
    private var cancellables: Set<AnyCancellable> = []
    weak var delegate: OrderHistoryViewModelDelegate?
    
    func onAppear() {
        service.fetchOrderIDs { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ids):
                    self?.fetch(ids: ids)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func fetch(ids: [Int]) {
        var orders: [Order] = []
        let group = DispatchGroup()
        
        for id in ids {
            group.enter()
            service.fetchOrder(id: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let order):
                        orders.append(order)
                    case .failure(let error):
                        print(error)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.orders = orders.sorted()
            delegate?.didUpdateOrders(orders: self.orders)
        }
    }
}
