//
//  MockPaymentsDataLoading.swift
//  DoorDashDebugging
//
//  Created by Mike Zaslavskiy on 5/10/24.
//

import Foundation
import Combine

// WARNING: DO NOT EDIT

final class MockPaymentsDataLoading: DataLoading {
    private let queue = DispatchQueue(label: "network", attributes: .concurrent)
    private let lock = NSLock()
    
    private var paymentMethods: [PaymentMethod] = [
        PaymentMethod.init(id: "1", name: "Visa", last4: "4409", type: .card),
        PaymentMethod.init(id: "2", name: "Amex", last4: "7309", type: .card),
        PaymentMethod.init(id: "3", name: "ApplePay", last4: nil, type: .applePay),
        PaymentMethod.init(id: "4", name: "Venmo", last4: nil, type: .venmo)
    ]
    
    func load(request: URLRequest) -> AnyPublisher<(request: URLRequest, data: Data, response: URLResponse), Error> {
        switch request.url?.lastPathComponent {
        case "paymentMethods":
            return Just(())
                .delay(
                    for: .seconds(Double.random(in: 0.8...1.2)),
                    scheduler: DispatchQueue(label: "background", target: queue)
                )
                .map {
                    let paymentMethodsData = try! JSONEncoder().encode(self.paymentMethods)
                    return (request: request, data: paymentMethodsData, response: URLResponse())
                }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case "deletePaymentMethod":
            let paymentMethodId = getQueryStringParameter(url: request.url!.absoluteString, param: "id")
            return Just(())
                .delay(
                    for: .seconds(0.1),
                    scheduler: DispatchQueue(label: "background", target: queue)
                )
                .map { [weak self] in
                    guard let self else { return }
                    
                    lock.lock()
                    paymentMethods.removeAll(where: { $0.id == paymentMethodId })
                    lock.unlock()
                }
                .map {
                    (request, Data(), URLResponse())
                }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case "addCard":
            return Just(())
                .delay(
                    for: .seconds(Double.random(in: 0.8...1.2)),
                    scheduler: DispatchQueue(label: "background", target: queue)
                )
                .map { [weak self] in
                    guard let self = self,
                          let httpBody = request.httpBody,
                          let paymentMethod = try? JSONDecoder().decode(PaymentMethod.self, from: httpBody)
                    else { return }
                    
                    lock.lock()
                    paymentMethods.append(paymentMethod)
                    lock.unlock()
                }
                .map {
                    (request, Data(), URLResponse())
                }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        default:
            return Fail(error: NSError(domain: "", code: 1))
                .eraseToAnyPublisher()
        }
    }
    
    private func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
