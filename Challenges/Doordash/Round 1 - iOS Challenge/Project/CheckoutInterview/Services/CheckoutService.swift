//
//  CheckoutService.swift
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
import Combine


protocol CheckoutServiceDelegate: AnyObject {
    func didSusscefully(with data: CheckoutModels.CheckoutModel)
    func didSusscefully(with orderId: String)
    func didFailure()
}

class CheckoutService {
    private let session = FakeNetworkSession()
    
    weak var delegate: CheckoutServiceDelegate?
    
    func fetchOrder() {
        session.getOrder { data in
            let model = try? JSONDecoder().decode(CheckoutModels.CheckoutModel.self, from: data)
            
            guard let model else {
                self.delegate?.didFailure()
                return
            }
            
            self.delegate?.didSusscefully(with: model)
        }
    }
    
    func submitOrder(orderId: String) {
        session.submitOrder(orderId: orderId) { data in
            self.delegate?.didSusscefully(with: orderId)
        }
    }
}
