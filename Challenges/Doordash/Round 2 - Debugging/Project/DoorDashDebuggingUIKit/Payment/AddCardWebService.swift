//
//  AddCardWebService.swift
//  DoorDashDebuggingUIKit
//
//  Created by Mike Zaslavskiy on 8/27/24.
//

import Foundation

protocol AddCardWebService {
    func addCard(card: PaymentMethod, completion: @escaping (Result<Void, Error>) -> Void)
}

extension NetworkService: AddCardWebService {}

extension AddCardWebService where Self: URLLoading {
    func addCard(card: PaymentMethod, completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "www.doordash.com/addCard")!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(card)
        
        process(request) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
