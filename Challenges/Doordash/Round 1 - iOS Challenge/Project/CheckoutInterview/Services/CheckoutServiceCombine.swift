//
//  CheckoutServiceCombine.swift
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

import Combine
import Foundation

class CheckoutServiceCombine {
    private let session = FakeNetworkSession()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchOrder() {
        session
            .getOrderPublisher
            .sink(
                receiveCompletion: { _ in
                },
                receiveValue: { data in
                    print(String(data: data, encoding: .utf8)!)
                }
            )
            .store(in: &cancellables)
    }
    
    func submitOrder(orderId: String) {
        session
            .submitOrderPublisher
            .sink(
                receiveCompletion: { _ in
                },
                receiveValue: { data in
                    print(String(data: data, encoding: .utf8)!)
                }
            )
            .store(in: &cancellables)
    }
}
