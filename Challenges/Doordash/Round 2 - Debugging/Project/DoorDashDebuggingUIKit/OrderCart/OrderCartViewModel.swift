//
//  OrderCartViewModel.swift
//  DoorDashDebuggingUIKit
//
//  Created by shawn wu on 8/12/24.
//

import Foundation

protocol OrderCartViewModelDelegate: AnyObject {
    func didUpdateCart(items: [OrderCartResponse.CartItem]?, total: String?, error: Error?)
}

class OrderCartViewModel {
    weak var delegate: OrderCartViewModelDelegate?
    
    private let service = NetworkService(urlLoader: MockOrderCartDataLoading()) // add dependency injection
    
    private var orderCart: OrderCartResponse?
    
    private var cartItems: [OrderCartResponse.CartItem] {
        orderCart?.cartItems ?? []
    }
    
    private var cartTotal: String {
        let total = cartItems.reduce(0) {
            $0 + $1.item.price * Double($1.quantity)
        }
        let roundedTotal = round(total * 100) / 100.0
        
        return String(format: "%.2f", roundedTotal)
    }
    
    func update(quantity: Int, itemId: String) {
        updateCart(quantity: quantity, itemId: itemId)
        fetchCartDetails()
    }
    
    func fetchCartDetails() {
        service.getOrderCart(withId: "123") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                orderCart = response
                delegate?.didUpdateCart(items: cartItems, total: cartTotal, error: nil)
            case .failure(let error):
                delegate?.didUpdateCart(items: nil, total: nil, error: error)
            }
        }
    }
    
    private func updateCart(quantity: Int, itemId: String) {
        service.updateOrderCart(cartId: "123", itemId: itemId, quantity: quantity, completion: { _ in })
    }
}

