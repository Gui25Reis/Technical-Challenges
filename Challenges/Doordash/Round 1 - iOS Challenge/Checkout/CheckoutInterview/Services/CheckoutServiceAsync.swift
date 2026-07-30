//
//  CheckoutServiceAsync.swift
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

import Foundation

class CheckoutServiceAsync {
    private let session = FakeNetworkSession()
    
    func fetchOrder() async {
        let data = await session.getOrder()
        print(String(data: data, encoding: .utf8)!)
    }
    
    func submitOrder(orderId: String) async {
        let data = await session.submitOrder(orderId: orderId)
        print(String(data: data, encoding: .utf8)!)
    }
}
