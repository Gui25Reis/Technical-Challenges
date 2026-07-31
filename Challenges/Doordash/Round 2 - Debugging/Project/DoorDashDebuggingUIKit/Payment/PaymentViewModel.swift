//
//  PaymentViewModel.swift
//  DoorDashDebuggingUIKit
//
//  Created by Mike Zaslavskiy on 8/27/24.
//

import Foundation

final class PaymentViewModel {
    protocol Delegate: AnyObject {
        func didFetch()
    }
    
    @Service private var paymentWebService: PaymentWebService
    @Service private var deleteCardWebService: DeleteCardWebService
    
    weak var delegate: Delegate?
    
    /// Array of payment methods displayed on the screen
    var paymentMethods: [PaymentMethod] = [] {
        didSet { delegate?.didFetch() }
    }
    
    /// Fetches the payment methods from a web service and updates the UI
    func getPaymentMethods() {
        paymentWebService.fetchPaymentMethods { result in
            switch result {
            case let .success(paymentMethods):
                self.paymentMethods = paymentMethods
            case .failure:
                assertionFailure()
            }
        }
    }
    
    func deleteCard(_ card: PaymentMethod, onSuccess: @escaping () -> Void) {
        deleteCardWebService.deletePaymentMethod(withId: card.id) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.paymentMethods.removeAll(where: { $0.id == card.id })
                onSuccess()
            }
        }
    }
}
