//
//  PaymentWebService.swift
//  DoorDashDebuggingUIKit
//
//  Created by Mike Zaslavskiy on 8/27/24.
//

import Foundation
import Combine

protocol PaymentWebService {
    func fetchPaymentMethods(completion: @escaping (Result<[PaymentMethod], Error>) -> Void)
}

extension NetworkService: PaymentWebService {}

extension PaymentWebService where Self: URLLoading {
    func fetchPaymentMethods(completion: @escaping (Result<[PaymentMethod], Error>) -> Void) {
        let request = URLRequest(url: URL(string: "www.doordash.com/paymentMethods")!)
        process(request) { result in
            do {
                let data = try result.get().data
                let paymentMethods = try JSONDecoder().decode([PaymentMethod].self, from: data)
                completion(.success(paymentMethods))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
